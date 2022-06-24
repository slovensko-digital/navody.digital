##
# Returns list of found businesses:
# $ businesses = Apps::BusinessRegisterApp::BusinessActs.new.search_business('my name')
#
# Returns list of acts for given business
# acts = Apps::BusinessRegisterApp::BusinessActs.new.search_acts(businesses.first)
#
module Apps
  module BusinessRegisterApp
    class BusinessActs
      def search_business(query)
        res = client.get('/orsr.webapiforms/search', s: query)

        if res.success?
          json = aspx_to_json(res.body)
          Business.array_from_json(json)
        else
          Rails.logger.error res.body
          raise "Api fail"
        end
      end

      def search_acts(business)
        res = client.get(
          '/orsr.webapiforms/search/listina',
          oddiel: business.oddiel,
          vlozka: business.vlozka,
          sud: business.sud,
        )
        if res.success?
          res.body
        else
          Rails.logger.error res.body
          raise "Api fail"
        end
      end

      def perform
      end

      def client
        Faraday.new('https://orsr.sk') do |faraday|
          faraday.request :json
          faraday.response :json
          faraday.response(:logger, Rails.logger, headers: false, bodies: false)
        end
      end

      def aspx_to_json(str)
        aspx_to_json = str.gsub(/^\(/, '').gsub(/\);$/, '')
        JSON.parse(aspx_to_json.force_encoding('UTF-8'))
      end

      class Business
        include ActiveModel::Model
        attr_accessor(:ico, :name, :address, :oddiel, :vlozka, :sud, :raw)

        def self.array_from_json(json)
          json['aaData'].map do |business|
            sub_data = JSON.parse(business[3])
            new(
              ico: business[0],
              name: business[1],
              address: business[2],
              oddiel: sub_data['oddiel'],
              vlozka: sub_data['vlozka'],
              sud: sub_data['sud'],
              raw: business,
            )
          end
        end
      end

      class Act
        include ActiveModel::Model
        attr_accessor(:raw, :name, :formatted_name, :type, :delivery_date, :serial_number, :page_count)

        def self.array_from_json(json)
          json['data'].map do |act|
            new(
              name: act['name'],
              formatted_name: act['formattedName'],
              type: act['type'],
              delivery_date: act['deliveryDate'],
              serial_number: act['serialNumber'],
              page_count: act['page_count'],
              raw: act,
            )
          end
        end
      end
    end
  end
end
