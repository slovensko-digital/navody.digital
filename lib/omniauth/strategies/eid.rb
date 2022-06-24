require 'omniauth'

module OmniAuth
  module Strategies
    class Eid
      include OmniAuth::Strategy

      attr_reader :eid_sub
      attr_reader :decoded_token
      attr_reader :payload

      option :fields, [:eid_sub]
      option :uid_field, :eid_sub
      option :auth_url
      option :public_key

      def request_phase
        redirect auth_url
      end

      def callback_phase
        encoded_token = request[:token]

        @eid_sub = parse_eid_sub(encoded_token)

        return fail!(:invalid_credentials) unless @eid_sub

        email = User.find_by(eid_sub: @eid_sub)&.email

        session[:eid_encoded_token] = encoded_token
        session[:eid_token_expires_at] = parse_eid_expires_at(encoded_token)

        @payload = {
          'eid_sub' => @eid_sub,
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

      def parse_eid_sub(token)
        parse_eid_token(token)&.first&.fetch('sub')
      end

      def parse_eid_expires_at(token)
        Time.zone.at(parse_eid_token(token)&.first&.fetch('exp'))
      end

      def parse_eid_token(token)
        if Rails.env.development?
          JWT.decode(token, nil, false)
        else
          JWT.decode(token, OpenSSL::PKey::RSA.new(public_key), true, algorithms: ['RS256'])
        end
      end

      def auth_url
        "#{options[:base_url]}/login"
      end

      def public_key
        options[:public_key]
      end
    end
  end
end
