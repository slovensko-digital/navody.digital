module Apps
  module EpVoteApp
    class ApplicationForm
      VOTE_DATE = Date.parse(ENV.fetch('EP_VOTE_DATE', '2024-06-08'))
      REQUEST_SENDING_DEADLINE = VOTE_DATE - 19.days

      include ActiveModel::Model

      attr_accessor :step
      attr_accessor :place
      attr_accessor :citizenship
      attr_accessor :sk_citizen_residency
      attr_accessor :eu_citizen_residency
      attr_accessor :eu_citizen_sk_resident
      attr_accessor :eu_citizen_non_sk_resident
      attr_accessor :delivery
      attr_accessor :full_name, :pin
      attr_accessor :authorized_person_full_name, :authorized_person_pin
      attr_accessor :street, :pobox, :municipality
      attr_accessor :same_delivery_address
      attr_accessor :delivery_street, :delivery_pobox, :delivery_municipality, :delivery_country
      attr_accessor :municipality_email
      attr_accessor :municipality_email_verified
      attr_accessor :back

      validates_presence_of :citizenship, message: 'Vyberte vaše občianstvo', on: :citizenship
      validates_presence_of :sk_citizen_residency, message: 'Vyberte áno pokiaľ máte trvalý pobyt na Slovensku', on: :sk_citizen_residency
      validates_presence_of :eu_citizen_residency, message: 'Vyberte áno pokiaľ máte trvalý pobyt na Slovensku', on: :eu_citizen_residency

      validates_presence_of :place, message: 'Vyberte kde plánujete voliť', on: :place

      validates_presence_of :delivery, message: 'Vyberte si spôsob prevzatia hlasovacieho preukazu', on: :delivery
      validates_exclusion_of :delivery, in: %w(post authorized_person),
                            if: -> { request_sending_expired? },
                             message: 'Lehota na zaslanie žiadosti o hlasovací preukaz uplynula 10.2.2020.', on: :delivery
      validates_exclusion_of :delivery, in: %w(person),
                            if: -> { pickup_expired? },
                             message: 'Termín na vybavenie hlasovacieho preukazu uplynul 28.2.2020.', on: :delivery

      validates_presence_of :full_name, message: 'Meno je povinná položka',
                            on: [:identity, :sk_citizen_world_resident, :authorized_person]
      validates_presence_of :pin, message: 'Rodné číslo je povinná položka',
                            on: [:identity, :sk_citizen_world_resident, :authorized_person]
      validates_presence_of :street, message: 'Zadajte ulicu alebo názov obce ak obec nemá ulice',
                            on: [:identity, :authorized_person]
      validates_presence_of :pobox, message: 'Zadajte poštové smerové čislo',
                            on: [:identity, :authorized_person]
      validates_presence_of :municipality, message: 'Vyberte obec',
                            on: [:identity, :authorized_person]

      validates_presence_of :authorized_person_full_name, message: 'Meno splnomocnenej osoby je povinná položka',
                            on: [:authorized_person]
      validates_presence_of :authorized_person_pin, message: 'Číslo občianskeho preukazu splnomocnenej osoby je povinná položka',
                            on: [:authorized_person]

      validates_presence_of :same_delivery_address, message: 'Zadajte kam chcete zaslať hlasovací preukaz',
                            on: :delivery_address
      validates_presence_of :delivery_street, message: 'Zadajte ulicu alebo názov obce ak obec nemá ulice',
                            on: [:delivery_address, :sk_citizen_world_resident],
                            if: -> (f) { f.custom_delivery_address? }
      validates_presence_of :delivery_pobox, message: 'Zadajte poštové smerové čislo',
                            on: [:delivery_address, :sk_citizen_world_resident],
                            if: -> (f) { f.custom_delivery_address? }
      validates_presence_of :delivery_municipality, message: 'Zadajte obec',
                            on: [:delivery_address, :sk_citizen_world_resident],
                            if: -> (f) { f.custom_delivery_address? }
      validates_presence_of :delivery_country, message: 'Zadajte štát',
                            on: [:delivery_address, :sk_citizen_world_resident],
                            if: -> (f) { f.custom_delivery_address? }

      def self.active?
        Date.current < VOTE_DATE
      end

      def minv_email
        "volby@minv.sk"
      end

      def custom_delivery_address?
        same_delivery_address == '0'
      end

      def municipality_email_verified?
        municipality_email_verified == "OK"
      end

      def full_address
        "#{street}, #{pobox} #{municipality}"
      end

      def go_back?
        back == "true"
      end

      def pickup_remaining_days
        (VOTE_DATE - Date.current).to_i - 1
      end

      def request_sending_remaining_days
        (REQUEST_SENDING_DEADLINE - Date.current).to_i
      end

      def pickup_expired?
        pickup_remaining_days < 0
      end

      def request_sending_expired?
        request_sending_remaining_days < 0
      end

      def from_slovakia_email_body
        ActionController::Base.new.render_to_string(
          partial: "apps/ep_vote_app/application_forms/from_slovakia_email_body",
          locals: { model: self },
        ).gsub(/\n/, "\r\n")
      end

      def from_slovakia_authorized_person_email_body
        ActionController::Base.new.render_to_string(
          partial: "apps/ep_vote_app/application_forms/from_slovakia_authorized_person_email_body",
          locals: { model: self },
        ).gsub(/\n/, "\r\n")
      end

      def run(listener)
        case step
        when 'start'
          start_step(listener)
        when 'citizenship'
          citizenship_step(listener)
        when 'sk_citizen_residency'
          sk_citizen_residency_step(listener)
        when 'eu_citizen_residency'
          eu_citizen_residency_step(listener)
        when 'eu_citizen_sk_resident'
          eu_citizen_sk_resident_step(listener)
        when 'eu_citizen_non_sk_resident'
          eu_citizen_non_sk_resident_step(listener)
        when 'sk_citizen_eu_resident'
          sk_citizen_eu_resident_step(listener)
        when 'sk_citizen_world_resident'
          sk_citizen_world_resident_step(listener)
        when 'place'
          place_step(listener)
        when 'delivery'
          delivery_step(listener)
        when 'identity'
          identity_step(listener)
        when 'authorized_person'
          authorized_person_step(listener)
        when 'authorized_person_send'
          authorized_person_send_step(listener)
        when 'address'
          address_step(listener)
        when 'delivery_address'
          delivery_address_step(listener)
        when 'other_nationality'
          other_nationality_step(listener)
        when 'home'
          home_step(listener)
        when 'person'
          person_step(listener)
        when 'send_email'
          send_email_step(listener)
        end
      end

      private

      def start_step(listener)
        listener.render :citizenship
      end

      def citizenship_step(listener)
        if go_back?
          listener.render :start
        elsif valid?(:citizenship)
          case citizenship
          when 'sk'
            listener.render :sk_citizen_residency
          when 'eu'
            listener.render :eu_citizen_residency
          when 'other'
            listener.redirect_to action: :other_nationality
          end
        else
          listener.render :citizenship
        end
      end

      def sk_citizen_residency_step(listener)
        if go_back?
          listener.render :citizenship
        elsif valid?(:sk_citizen_residency)
          case sk_citizen_residency
          when 'sk'
            listener.render :place
          when 'eu'
            listener.redirect_to action: :sk_citizen_eu_resident
          when 'other'
            listener.redirect_to action: :sk_citizen_world_resident
          end
        else
          listener.render :sk_citizen_residency
        end
      end

      def eu_citizen_residency_step(listener)
        if go_back?
          listener.render :citizenship
        elsif valid?(:eu_citizen_residency)
          case eu_citizen_residency
          when 'sk'
            listener.redirect_to action: :eu_citizen_sk_resident
          when 'other'
            listener.redirect_to action: :eu_citizen_non_sk_resident
          end
        else
          listener.render :eu_citizen_residency
        end
      end

      def eu_citizen_sk_resident_step(listener)
        if go_back?
          listener.render :eu_citizen_residency
        else
          listener.render :eu_citizen_sk_resident
        end
      end

      def eu_citizen_non_sk_resident_step(listener)
        if go_back?
          listener.render :eu_citizen_residency
        else
          listener.render :eu_citizen_non_sk_resident
        end
      end

      def place_step(listener)
        if go_back?
          listener.render :sk_citizen_residency
        elsif valid?(:place)
          case place
          when 'home'
            listener.redirect_to action: :home
          when 'sk'
            listener.redirect_to action: :delivery
          end
        else
          listener.render :place
        end
      end

      def delivery_step(listener)
        if go_back?
          listener.render :place
        elsif valid?(:delivery)
          case delivery
          when 'post'
            listener.render :identity
          when 'authorized_person'
            listener.render :authorized_person
          when 'person'
            listener.redirect_to action: :person
          end
        else
          listener.render :delivery
        end
      end

      def identity_step(listener)
        if go_back?
          listener.render :delivery
        elsif valid?(:identity)
          listener.render :delivery_address
        else
          listener.render :identity
        end
      end

      def delivery_address_step(listener)
        if go_back?
          listener.render :identity
        elsif valid?(:delivery_address)
          listener.render :send_email
        else
          listener.render :delivery_address
        end
      end

      def authorized_person_step(listener)
        if go_back?
          listener.render :delivery
        elsif valid?(:authorized_person)
          listener.render :authorized_person_send
        else
          listener.render :authorized_person
        end
      end

      def authorized_person_send_step(listener)
        if go_back?
          listener.render :authorized_person
        else
          listener.render :authorized_person_send
        end
      end

      def sk_citizen_world_resident_step(listener)
        if go_back?
          listener.render :sk_citizen_residency
        else
          listener.render :sk_citizen_world_resident
        end
      end

      def sk_citizen_eu_resident_step(listener)
        if go_back?
          listener.render :sk_citizen_residency
        else
          listener.render :sk_citizen_eu_resident
        end
      end

      def other_nationality_step(listener)
        if go_back?
          listener.render :citizenship
        else
          listener.render :other_nationality
        end
      end

      def home_step(listener)
        if go_back?
          listener.render :place
        else
          listener.render :home
        end
      end

      def person_step(listener)
        if go_back?
          listener.render :delivery
        else
          listener.render :person
        end
      end

      def send_email_step(listener)
        if go_back?
          listener.render :delivery_address
        else
          listener.render :send_email
        end
      end
    end
  end
end
