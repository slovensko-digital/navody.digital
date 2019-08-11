require 'omniauth'

module OmniAuth
  module Strategies
    class MagicLink
      include OmniAuth::Strategy

      attr_reader :payload

      option :fields, [:email]
      option :uid_field, :email
      option :on_send_link, nil
      option :info_path, nil
      option :code_lifetime, 10.minutes

      def request_phase
        email = request[:email]
        raise InvalidEmailError unless EmailValidator.new(email).valid?

        token = generate_magic_code(email, session.id)

        options[:on_send_link]&.call(email, token)

        redirect info_url + '?email=' + email
      end

      def callback_phase
        token = request[:token]
        @payload = parse_payload(token)

        return fail!(:invalid_credentials) unless payload

        super
      end

      uid do
        raw_info[:email]
      end

      info do
        raw_info
      end

      def raw_info
        payload
      end

      protected

      def parse_payload(token)
        payload = verifier.verify(token, purpose: :magic_link).symbolize_keys
        return false if payload[:session_id] != session.id

        payload
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        false
      end

      def generate_magic_code(email, session_id)
        verifier
          .generate(
            verifier_payload(email, session_id),
            expires_in: options[:code_lifetime],
            purpose: :magic_link
          )
      end

      def info_path
        options[:info_path] || "#{path_prefix}/#{name}/info"
      end

      def info_url
        full_host + script_name + info_path
      end

      def secret_key
        Rails.application.secrets.secret_key_base
      end

      def verifier_payload(email, session_id)
        { email: email, session_id: session_id }
      end

      def verifier
        ActiveSupport::MessageVerifier.new(secret_key)
      end

      class InvalidEmailError < StandardError
      end
    end
  end
end
