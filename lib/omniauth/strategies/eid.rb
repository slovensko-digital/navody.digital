require 'omniauth'

module OmniAuth
  module Strategies
    class Eid
      include OmniAuth::Strategy

      attr_reader :eid_token
      attr_reader :payload

      option :fields, [:eid_sub]
      option :uid_field, :eid_sub
      option :auth_url
      option :config

      def request_phase
        redirect auth_url
      end

      def callback_phase
        encoded_token = request[:token]

        @eid_token = EidToken.new(encoded_token, config: config)

        return fail!(:invalid_credentials) unless eid_sub

        email = User.find_by(eid_sub: eid_sub)&.email

        @payload = {
          'eid_sub' => eid_sub,
          'eid_encoded_token' => encoded_token,
          'email' => email
        }

        super
      end

      def on_callback_path?
        on_path?('/login')
      end

      uid do
        eid_sub
      end

      info do
        payload
      end

      private

      def eid_sub
        eid_token.sub
      end

      def auth_url
        "#{config[:base_url]}/login"
      end

      def config
        options[:config]
      end
    end
  end
end
