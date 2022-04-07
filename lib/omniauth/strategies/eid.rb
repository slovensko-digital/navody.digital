require 'omniauth'

module OmniAuth
  module Strategies
    class Eid
      include OmniAuth::Strategy

      attr_reader :payload
      attr_reader :token

      option :fields, [:sub]
      option :uid_field, :sub

      def request_phase
        # TODO read from ENV
        redirect 'https://slovensko-sk-api.ekosystem.slovensko.digital/login'
      end

      def callback_phase
        @token = parse_token(request[:token])
        @payload = {
          email: '',
          token: token,
        }.deep_stringify_keys

        return fail!(:invalid_credentials) unless payload[:token]

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
        # TODO: enable verification back
        # TODO: read public ssh key from ENV
        JWT.decode(token, nil, false, algorithms: ['RS256'])
          &.first
      end
    end
  end
end
