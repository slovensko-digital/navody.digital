require 'omniauth'

module OmniAuth
  module Strategies
    class Eid
      include OmniAuth::Strategy

      attr_reader :payload
      attr_reader :token

      option :fields, [:sub]
      option :uid_field, :sub
      option :auth_url
      option :public_key

      def request_phase
        redirect auth_url
      end

      def callback_phase
        @token = parse_token(request[:token])
        @payload = {
          email: '',
          token: token,
        }.deep_stringify_keys

        return fail!(:invalid_credentials) unless payload['token']

        super
      end

      def on_callback_path?
        on_path?('/login')
      end

      uid do
        token['sub']
      end

      info do
        payload
      end

      private

      def parse_token(token)
        JWT
          .decode(token, OpenSSL::PKey::RSA.new(public_key), true, algorithms: ['RS256'])
          &.first
      end

      def auth_url
        options[:url]
      end

      def public_key
        options[:public_key]
      end
    end
  end
end
