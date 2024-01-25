module Apps
  module PresidentVoteApp
    class ApplicationForm
      FIRST_ROUND_DATE = Date.parse(ENV.fetch('APP_PRESIDENT_VOTE_DATE', '2023-09-30'))
      REQUEST_SENDING_DEADLINE_DATE = Date.parse(ENV.fetch('APP_PRESIDENT_REQUEST_SENDING_DEADLINE_DATE', '2023-09-08'))

      include ActiveModel::Model

      attr_accessor :step
      attr_accessor :place_first_round
      attr_accessor :place_second_round
      attr_accessor :place
      attr_accessor :sk_citizen
      attr_accessor :permanent_resident
      attr_accessor :delivery
      attr_accessor :full_name, :pin
      attr_accessor :authorized_person_full_name, :authorized_person_pin
      attr_accessor :street, :pobox, :municipality
      attr_accessor :same_delivery_address
      attr_accessor :delivery_street, :delivery_pobox, :delivery_municipality, :delivery_country
      attr_accessor :municipality_email
      attr_accessor :municipality_email_verified
      attr_accessor :back

      # validates_presence_of :place_first_round, message: 'Vyberte si jednu z možností v prvom kole',
      #                       on: [:place, :identity, :delivery_address, :authorized_person]
      # validates_presence_of :place_second_round, message: 'Vyberte si jednu z možností v druhom kole',
      #                       on: [:place, :identity, :delivery_address, :authorized_person]

      validates_presence_of :sk_citizen, message: 'Vyberte áno pokiaľ ste občan Slovenskej republiky', on: :sk_citizen
      validates_presence_of :permanent_resident, message: 'Vyberte áno pokiaľ máte trvalý pobyt na Slovensku', on: :permanent_resident

      validates_presence_of :delivery, message: 'Vyberte si spôsob prevzatia hlasovacieho preukazu', on: :delivery
      validates_exclusion_of :delivery, in: %w(post authorized_person),
                            if: -> { request_sending_expired? },
                             message: 'Lehota na zaslanie žiadosti o hlasovací preukaz uplynula 10.2.2020.', on: :delivery
      validates_exclusion_of :delivery, in: %w(person),
                            if: -> { pickup_expired? },
                             message: 'Termín na vybavenie hlasovacieho preukazu uplynul 28.2.2020.', on: :delivery

      validates_presence_of :full_name, message: 'Meno je povinná položka',
                            on: [:identity, :world_abroad_permanent_resident, :authorized_person]
      validates_presence_of :pin, message: 'Rodné číslo je povinná položka',
                            on: [:identity, :world_abroad_permanent_resident, :authorized_person]
      # validate :pin_is_ok, on: [:identity, :world_abroad_permanent_resident, :authorized_person]
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
                            on: [:delivery_address, :world_abroad_permanent_resident],
                            if: -> (f) { f.custom_delivery_address? }
      validates_presence_of :delivery_pobox, message: 'Zadajte poštové smerové čislo',
                            on: [:delivery_address, :world_abroad_permanent_resident],
                            if: -> (f) { f.custom_delivery_address? }
      validates_presence_of :delivery_municipality, message: 'Zadajte obec',
                            on: [:delivery_address, :world_abroad_permanent_resident],
                            if: -> (f) { f.custom_delivery_address? }
      validates_presence_of :delivery_country, message: 'Zadajte štát',
                            on: [:delivery_address, :world_abroad_permanent_resident],
                            if: -> (f) { f.custom_delivery_address? }

      def self.active?
        (Date.current - FIRST_ROUND_DATE).to_i < 14
      end

      def minv_email
        "volby@minv.sk"
      end

      def year
        FIRST_ROUND_DATE.year
      end

      def custom_delivery_address?
        same_delivery_address == '0' || step == 'world_abroad_permanent_resident'
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

      def place_choice
        if place_first_round == 'sk'
          if place_second_round == 'sk'
            'obe kolá'
          else
            'prvé kolo'
          end
        else
          'druhé kolo'
        end
      end

      def pickup_remaining_days
        if place_first_round == 'sk'
          (FIRST_ROUND_DATE - Date.current).to_i - 1
        else
          (FIRST_ROUND_DATE - Date.current).to_i + 13
        end
      end

      def request_sending_remaining_days
        if place_first_round == 'sk'
          (REQUEST_SENDING_DEADLINE_DATE - Date.current).to_i
        else
          (REQUEST_SENDING_DEADLINE_DATE - Date.current).to_i + 14
        end
      end

      def pickup_expired?
        pickup_remaining_days < 1
      end

      def request_sending_first_round_expired?
        false
      end

      def request_sending_expired?
        Date.current > REQUEST_SENDING_DEADLINE_DATE
      end

      def from_slovakia_email_body
        ActionController::Base.new.render_to_string(
          partial: "apps/president_vote_app/application_forms/from_slovakia_email_body",
          locals: { model: self },
        ).gsub(/\n/, "\r\n")
      end

      def from_slovakia_authorized_person_email_body
        ActionController::Base.new.render_to_string(
          partial: "apps/president_vote_app/application_forms/from_slovakia_authorized_person_email_body",
          locals: { model: self },
        ).gsub(/\n/, "\r\n")
      end

      private def pin_is_ok
        return errors.add(:pin, 'Rodné číslo je pocinná položka') if pin.blank?

        begin
          pin.to_i
        rescue ArgumentError
          return errors.add(:pin, 'Rodné číslo obsahuje neplatné znaky')
        end

        pin = self.pin.gsub(%r{/}, '')
        return errors.add(:pin, 'Rodné číslo nie je deliteľné číslom 11') if pin.length == 10 and pin.to_i % 11 != 0
        return errors.add(:pin, 'Rodné číslo má nesprávnu dĺžku') if pin.length != 10 and pin.length != 9

        case pin[2..3].to_i
        when 0, 13..50, 63..99
          return errors.add(:pin, 'Rodné číslo obsahuje neplatný mesiac')
        end

        month = pin[2..3].to_i % 50
        year = pin[0..1].to_i + (pin[2..3].to_i > 12 ? 1900 : 2000)
        begin
          Date.new(year, month, pin[4..5].to_i)
        rescue ArgumentError
          errors.add(:pin, 'Rodné číslo obsahuje neplatný dátum')
        end
      end

      def run(listener)
        case step
        when 'start'
          start_step(listener)
        when 'place'
          place_step(listener)
        when 'sk_citizen'
          sk_citizen_step(listener)
        when 'permanent_resident'
          permanent_resident_step(listener)
        when 'delivery'
          delivery_step(listener)
        when 'identity'
          identity_step(listener)
        when 'authorized_person'
          authorized_person_step(listener)
        when 'address'
          address_step(listener)
        when 'delivery_address'
          delivery_address_step(listener)
        when 'world_abroad_permanent_resident'
          world_abroad_permanent_resident_step(listener)
        when 'non_sk_nationality'
          non_sk_nationality(listener)
        when 'home'
          home(listener)
        end
      end

      private def start_step(listener)
        self.step = 'sk_citizen'
        listener.render :sk_citizen
      end

      private def sk_citizen_step(listener)
        if go_back?
          self.step = 'start'
          listener.render :start
        elsif valid?(:sk_citizen)
          case sk_citizen
          when 'yes'
            self.step = 'permanent_resident'
            listener.render :permanent_resident
          when 'no'
            listener.redirect_to action: :non_sk_nationality
          end
        else
          listener.render :sk_citizen
        end
      end

      private def permanent_resident_step(listener)
        if go_back?
          self.step = 'sk_citizen'
          listener.render :sk_citizen
        elsif valid?(:permanent_resident)
          case permanent_resident
          when 'yes'
            self.step = 'place'
            listener.render :place
          when 'no'
            listener.redirect_to action: :world
          end
        else
          listener.render :permanent_resident
        end
      end

      private def place_step(listener)
        if go_back?
          self.step = 'permanent_resident'
          listener.render :permanent_resident
        elsif valid?(:place)
          if place_first_round == 'sk' || place_second_round == 'sk'
            self.place_first_round = place_first_round
            self.place_second_round = place_second_round
            self.step = 'delivery'
            listener.render :delivery
          else
            listener.redirect_to action: :home
          end
        else
          listener.render :place
        end
      end

      private def delivery_step(listener)
        if go_back?
          self.step = 'place'
          listener.render :place
        elsif valid?(:delivery)
          case delivery
          when 'post'
            self.step = 'identity'
            listener.render :identity
          when 'authorized_person'
            self.step = 'authorized_person'
            listener.render :authorized_person
          when 'person'
            listener.redirect_to action: :person
          end
        else
          listener.render :delivery
        end
      end

      private def identity_step(listener)
        if go_back?
          self.step = 'delivery'
          listener.render :delivery
        elsif valid?(:identity)
          self.step = 'delivery_address'
          listener.render :delivery_address
        else
          listener.render :identity
        end
      end

      private def delivery_address_step(listener)
        if go_back?
          self.step = 'identity'
          listener.render :identity
        elsif valid?(:delivery_address)
          self.step = 'send'
          listener.render :send
        else
          listener.render :delivery_address
        end
      end

      private def authorized_person_step(listener)
        if go_back?
          self.step = 'delivery'
          listener.render :delivery
        elsif valid?(:authorized_person)
          self.step = 'authorized_person_send'
          listener.render :authorized_person_send
        else
          self.step = 'authorized_person'
          listener.render :authorized_person
        end
      end

      private def world_abroad_permanent_resident_step(listener)
        if go_back?
          self.step = 'permanent_resident'
          listener.render :permanent_resident
        else
          listener.render :world_abroad_permanent_resident
        end
      end

      private def non_sk_nationality(listener)
        if go_back?
          self.step = 'sk_citizen'
          listener.render :sk_citizen
        else
          listener.render :non_sk_nationality
        end
      end

      private def home(listener)
        if go_back?
          self.step = 'place'
          listener.render :place
        else
          listener.render :home
        end
      end
    end
  end
end
