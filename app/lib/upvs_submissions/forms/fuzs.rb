module UpvsSubmissions
  module Forms
    class Fuzs
      include ActiveModel::Model

      attr_accessor(:cin, :name, :address, :court, :org_type, :registration_number, :stakeholders)

      def initialize(cin: nil, name: nil, address: nil, court: nil, registration_number: nil, type: nil, stakeholders: nil)
        corporate_body = get_datahub_corporate_body(cin) unless name

        @cin = cin
        @name = name || corporate_body['name']
        @address = address ? load_address_from_json(address) : Address.new(*(address_params(corporate_body).values))
        @court = court ? load_court_from_json(court) : load_court(corporate_body)
        @org_type = type || corporate_body['registration_number']&.split('/')[0]
        @registration_number = registration_number || corporate_body['registration_number']&.split('/')[1]

        raise FuzsError.new unless sro?

        if name
          @registration_number = registration_number
          @stakeholders = load_stakeholders_from_json(stakeholders)
        else
          or_sr_document = OrSrRecordFetcher.get_document(cin)
          @deposit_entries = OrSrRecordFetcher.get_stakeholders_deposit_entries(or_sr_document)
          @identifiers_status = OrSrRecordFetcher.get_stakeholders_identifiers_status(or_sr_document)
          @stakeholders = load_stakeholders_from_cb(corporate_body)

          raise FuzsError.new unless OrSrRecordFetcher.get_stakeholders(or_sr_document).size == @stakeholders.size
        end
      end

      def sro?
        @org_type&.casecmp('sro') == 0
      end

      def all_stakeholders_ok?
        @stakeholders.all? { |stakeholder| stakeholder.identifier_ok }
      end

      def stakeholders_with_missing_identifiers
        @stakeholders.select{ |stakeholder| !stakeholder.identifier_ok }
      end

      def all_stakeholders_persons?
        @stakeholders.all? { |stakeholder| stakeholder.is_person? }
      end

      def all_stakeholders_corporate_bodies?
        @stakeholders.all? { |stakeholder| !stakeholder.is_person? }
      end

      class Address
        include ActiveModel::Model

        attr_accessor(:street, :number, :postal_code, :municipality, :municipality_identifier, :country, :country_identifier)

        def initialize(street, building_number, reg_number, municipality, postal_code, country, with_identifiers)
          @street = street
          registration_number = (reg_number != 0 ? reg_number : nil)
          @number = join_numbers(building_number, registration_number)
          @postal_code = postal_code
          @municipality = municipality
          @country = country
          @municipality_identifier = with_identifiers ? load_municipality_identifier : nil
          @country_identifier = with_identifiers ? load_country_identifier : nil
        end

        private

        def join_numbers(building_number, reg_number)
          [reg_number, building_number].compact.join('/')
        end

        def load_municipality_identifier
          municipality_code_list_object = CodeList::Municipality.where("value ilike ?", @municipality&.strip).take
          municipality_code_list_object&.identifier
        end

        def load_country_identifier
          country_code_list_object = CodeList::Country.where("value ilike ?", @country&.strip).take
          country_code_list_object&.identifier
        end
      end

      class Stakeholder
        include ActiveModel::Model

        attr_accessor(
          :full_name, :cin, :foreign, :identifier, :other_identifier, :other_identifier_type, :date_of_birth,
          :address,
          :person_given_names, :person_family_names, :person_prefixes, :person_postfixes,
          :deposit_entries, :deposit, :deposit_currency, :paid_deposit, :paid_deposit_currency,
          :identifier_ok
        )

        def initialize(
          full_name: nil, cin: nil, foreign: nil, identifier: nil, other_identifier: nil, other_identifier_type: nil, date_of_birth: nil,
          person_given_names: nil, person_family_names: nil, person_prefixes: nil, person_postfixes: nil,
          address_street: nil, address_reg_number: nil, address_building_number: nil, address_postal_code: nil, address_municipality: nil, address_country: nil,
          all_deposit_entries: nil, identifiers_status: nil,
          address: nil, deposit_entries: nil, identifier_ok: nil
        )
          @full_name = full_name
          @cin = cin
          @foreign = foreign
          @identifier = identifier
          @other_identifier = other_identifier
          @other_identifier_type = other_identifier_type
          @date_of_birth = Date.parse(date_of_birth) if date_of_birth
          @address = address ? load_address_from_json(address) : Address.new(address_street, address_building_number, address_reg_number, address_municipality, address_postal_code, address_country, true)
          @person_given_names = person_given_names
          @person_family_names = person_family_names
          @person_prefixes = person_prefixes
          @person_postfixes = person_postfixes
          @deposit_entries = deposit_entries || filter_deposit_entries(all_deposit_entries)&.map{ |entry| Deposit.new(*(entry.except("name")).values) }
          @identifier_ok = identifiers_status ? identifier_status(identifiers_status) : identifier_ok
        end

        def name
          return [[prefixes.presence, given_name, family_name].compact.join(' '), postfixes.presence].compact.join(', ') if is_person?
          full_name
        end

        def given_name
          @person_given_names.compact.join(' ')
        end

        def family_name
          @person_family_names.compact.join(' ')
        end

        def postfixes
          @person_postfixes.compact.join(' ')
        end

        def prefixes
          @person_prefixes.compact.join(' ')
        end

        def is_person?
          @person_family_names.present? && !@full_name.present?
        end

        def set_if_foreign(nationality: nil)
          @foreign = (nationality == 'sr' ? false : true)
        end

        def set_date_of_birth(year: nil, month: nil, day: nil)
          return unless is_person?

          year, month, day = get_date_of_birth_from_identifier(@identifier) unless year.present?
          @date_of_birth = Date.new(year.to_i, month.to_i, day.to_i)
        end

        def load_address_from_json(data)
          Address.new(data['street'], data['building_number'], data['reg_number'], data['municipality'], data['postal_code'], data['country'], true)
        end

        def other_identifier_type_data
          id, value, code = nil, nil, nil

          case @other_identifier_type
          when 'ID'
            id, value, code = 1, 'preukaz totožnosti', 'ID'
          when 'CD'
            id, value, code = 2, 'cestovný doklad', 'CD'
          when 'DPC'
            id, value, code = 3, 'doklad o pobyte cudzinca', 'DPC'
          when 'IIU'
            id, value, code = 4, 'iný identifikačný údaj', 'IIU'
          end

          { :id => id, :value => value, :code => code }
        end

        private

        def get_date_of_birth_from_identifier(identifier)
          day = identifier[4..5].to_i
          month = identifier[2..3].to_i
          year = identifier[0..1].to_i

          month = (month > 50 ? month - 50 : month)
          year += (year > 20 ? 1900 : 2000)

          [year, month, day]
        end

        def filter_deposit_entries(entries)
          entries&.select{ |entry| (entry["name"].include?(family_name) && entry["name"].include?(given_name)) }
        end

        def identifier_status(status)
          ok = status[:ok].select{ |entry| (entry.include?(family_name) && entry.include?(given_name)) }
          !ok.empty?
        end

        class Deposit
          include ActiveModel::Model

          attr_accessor(:deposit, :deposit_currency, :paid_deposit, :paid_deposit_currency)

          def initialize(deposit, deposit_currency, paid_deposit, paid_deposit_currency)
            @deposit = deposit
            @deposit_currency = CodeList::Currency.find_by(code: deposit_currency)
            @paid_deposit = paid_deposit
            @paid_deposit_currency = CodeList::Currency.find_by(code: paid_deposit_currency)
          end
        end
      end

      class FuzsError < StandardError
      end

      private

      def get_datahub_corporate_body(cin, client: Faraday, datahub_url: ENV.fetch('DATAHUB_URL'), access_token: ENV.fetch('DATAHUB_ACCESS_TOKEN'))
        params = {
          :q => "cin:#{cin}",
          :expand => 'rpo_organizations',
          :access_token => access_token
        }

        response = client.get("#{datahub_url}/api/datahub/corporate_bodies/search?#{params.to_query}")
        JSON.parse(response.body)
      end

      def effective_rpo_organization(organizations)
        orgs = organizations.select{ |org| org['effective_to'] == nil }

        raise FuzsError.new if orgs.size != 1

        orgs.first
      end

      def load_address_from_json(data)
        Address.new(data['street'], data['building_number'], data['reg_number'], data['municipality'], data['postal_code'], data['country'], true)
      end

      def load_court_from_json(data)
        CodeList::Court.where("name ilike ?", data['name']).take
      end

      def load_court(corporate_body)
        registration_office = corporate_body['registration_office'].sub('Okresný súd ', '')

        court = CodeList::Court.where("name ilike ?", registration_office.strip).take

        raise FuzsError.new unless court

        court
      end

      def load_stakeholders_from_cb(corporate_body)
        rpo_organization = effective_rpo_organization(corporate_body['rpo_organizations'])

        stakeholders_data = rpo_organization["stakeholder_entries"].select{ |stakeholder| stakeholder['effective_to'] == nil }

        stakeholders_data&.map do |data| Stakeholder.new(
          full_name: data['full_name'], cin: data['cin'],
          person_given_names: data['person_given_names'], person_family_names: data['person_family_names'], person_prefixes: data['person_prefixes'], person_postfixes: data['person_postfixes'],
          address_street: data['address_street'],  address_reg_number: data['address_reg_number'],  address_building_number: data['address_building_number'],  address_postal_code: data['address_postal_code'], address_municipality: data['address_municipality'], address_country: data['address_country'],
          all_deposit_entries: @deposit_entries, identifiers_status: @identifiers_status
        )
        end
      end

      def load_stakeholders_from_json(stakeholders)
        @stakeholders = stakeholders&.map { |stakeholder| Stakeholder.new(
          full_name: stakeholder['full_name'], cin: stakeholder['cin'], address: stakeholder['address'],
          foreign: stakeholder['foreign'], identifier: stakeholder['identifier'], other_identifier: stakeholder['other_identifier'], other_identifier_type: stakeholder['other_identifier_type'], date_of_birth: stakeholder['date_of_birth'],
          person_given_names: stakeholder['person_given_names'], person_family_names: stakeholder['person_family_names'], person_prefixes: stakeholder['person_prefixes'], person_postfixes: stakeholder['person_postfixes'],
          deposit_entries: stakeholder['deposit_entries'], identifier_ok: stakeholder['identifier_ok']
        )}
      end

      def company_params(company)
        company.slice('name', 'cin').merge('address_params' => address_params(company))
      end

      def address_params(address, with_identifiers: true)
        address.slice('street', 'building_number', 'reg_number', 'municipality', 'postal_code', 'country').merge('with_identifiers' => with_identifiers)
      end
    end
  end
end
