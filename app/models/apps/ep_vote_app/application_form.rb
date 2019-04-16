module Apps
  module EpVoteApp
    class ApplicationForm
      include ActiveModel::Model

      attr_accessor :step
      attr_accessor :place
      attr_accessor :sk_citizen
      attr_accessor :delivery
      attr_accessor :full_name, :pin, :nationality
      attr_accessor :street, :pobox, :municipality

      validates_presence_of :place, message: 'Vyberte si jednu z možností', on: :place

      validates_presence_of :sk_citizen, message: 'Vyberte áno pokiaľ ste občan Slovenskej republiky', on: :sk_citizen

      validates_presence_of :delivery, message: 'Vyberte si spôsob prevzatia hlasovacieho preukazu', on: :delivery


      validates_presence_of :full_name, message: 'Meno je povinná položka', on: :identity
      validates_presence_of :pin, message: 'Rodné číslo je povinná položka', on: :identity
      validates_presence_of :nationality, message: 'Štátna príslušnosť je povinná položka', on: :identity

      def run(listener)
        case step
        when 'place'
          place_step(listener)
        when 'sk_citizen'
          sk_citizen_step(listener)
        when 'delivery'
          delivery_step(listener)
        when 'identity'
          identity_step(listener)
        end
      end

      private

      def place_step(listener)
        if valid?(:place)
          case place
          when 'home'
            listener.render :home
          when 'sk'
            self.step = 'sk_citizen'
            listener.render :sk_citizen
          when 'eu'
            listener.render :eu
          when 'world'
            listener.render :world
          end
        else
          listener.render :place
        end
      end

      def sk_citizen_step(listener)
        if valid?(:sk_citizen)
          case sk_citizen
          when 'yes'
            self.step = 'delivery'
            listener.render :delivery
          when 'no'
            listener.render :non_sk_nationality
          end
        else
          listener.render :sk_citizen
        end
      end

      def delivery_step(listener)
        if valid?(:delivery)
          case delivery
          when 'post'
            self.step = 'identity'
            listener.render :identity
          when 'person'
            listener.render :person
          end
        else
          listener.render :delivery
        end
      end


      def identity_step(listener)
        if valid?(:identity)
          self.step = 'address'
          listener.render :address
        else
          listener.render :identity
        end
      end
    end
  end
end
