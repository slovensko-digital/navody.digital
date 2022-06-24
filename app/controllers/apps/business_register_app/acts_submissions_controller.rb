module Apps
  module BusinessRegisterApp
    class ActsSubmissionsController < ApplicationController
      def index

      end

      def submit
        recipient_uri = "ico://sk/83369509"
        sender_uri = "ico://sk/83130041"
        obo_token = "eyJjdHkiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJleHAiOjE2NTYwOTM3NjgsImp0aSI6IjI2YmZiNTQ4LWZiZWItNDllYS04MmM5LTY5NjNhOGM3NmIzNiIsIm9ibyI6ImV5SmhiR2NpT2lKU1V6STFOaUo5LmV5SnpkV0lpT2lKcFkyODZMeTl6YXk4NE16RXpNREEwTVNJc0ltVjRjQ0k2TVRZMU5qQTVORFk0Tnl3aWJtSm1Jam94TmpVMk1Ea3pORGczTENKcFlYUWlPakUyTlRZd09UTTBPRGNzSW01aGJXVWlPaUpKWkdWdWRHbDBZU0E0TXpFek1EQTBNU0lzSW5OamIzQmxjeUk2V3lKemEzUmhiR3N2Y21WalpXbDJaU0lzSW5OcmRHRnNheTl5WldObGFYWmxYMkZ1WkY5ellYWmxYM1J2WDI5MWRHSnZlQ0lzSW5OcmRHRnNheTl6WVhabFgzUnZYMjkxZEdKdmVDSXNJbk5yZEdGc2F5OXdjbVZ3WVhKbFgyWnZjbDlzWVhSbGNsOXlaV05sYVhabElpd2lkWEIyY3k5aGMzTmxjblJwYjI0aUxDSjFjSFp6TDJsa1pXNTBhWFI1SWwwc0ltcDBhU0k2SW1FME5Ea3dZbVF6TFdaak1UVXROR1kxT1MwNE1XTmpMVFl5T0RSaFltVmhaR0UzTmlKOS5xc2tzbEdmLVRNX0hFSlI3SWc1SUZKaWRFdTFJd3RNWmJJLTI0aUJhWG02QXpSUHVpd3JYVGdtOHZDQ2ZkUDRPZU9KdDBuMnYtdGFFdjB3djRZbHhIeFFSMXNLalJ1Yk15cG43NVdXYmlnREpTSER6WWN4NHBheXNkcUU5eUdIczk3N3hPbk50VzNMX3pHNE1DbUtRMjVMM2FfYjE1MThYd0RwbENoa1pBWG5TSWhJd3lsdW92aGNBSjN6dW5CZm1HbnlBWXdFeDN1RzFhTHhGX2pnU1Jkb0ZBQnhVUU1xelg0NXdvdXAyRXk3ZTlnYjEzeGRhTWl5dGpmQm9NWEdLWlZYTEQxTzhXRWpXa3VlYjJBN19PR0wyUlBCaW5VT1R1UmZUamlCVFBRbkZETmJmX1gzSTN3SEZPcmkySFpBVDZQajdxSXFZQ2tuXzQ5Vm9kQ3c2MFEifQ.eFCjmpQ_W6lcBY2jAThpKY7ln18JWdrHAr1MITrv6_c1BguksXTaviJB92bsZoKHbGmK9Hpl5H-myilM_zduB49cLgtmcCchAfck7_j-gCbbYWGPay5QPQOPTL3RDb3YvIl_nyC6CFjOO4YX6h51dGu59OIVB5CFz5E7zJ02W8H44JrH3opeiljt46C6IbXst86nWLemYMXPcDW317k7-vyXBgXljthDndpw4Tq88vqYy-sjC4sxwGdCWYSouoXp3DM_wZxAjrrUdoNeod0cDKyDe2CZ7lsQnmVmGSubp5LU3UyHsrSNsLVKHI47-TW_OXeCOkeM5Gx7rHMxTMw3_Q"
        application = UpvsSubmissions::Forms::ApplicationForDocumentCopy.new(recipient_uri: recipient_uri, sender_uri: sender_uri, form_params: {})
        sktalk_message = UpvsSubmissions::SktalkMessageBuilder.new.build_sktalk_message(application)

        headers =  {
          "Content-Type": "application/json"
        }

        data =  {
          message: sktalk_message
        }.to_json

        url = "http://localhost:4000/api/sktalk/receive_and_save_to_outbox?token=#{obo_token}"

        Faraday.post(url, data, headers)
      end
    end
  end
end
