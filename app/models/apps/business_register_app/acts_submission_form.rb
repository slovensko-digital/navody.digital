module Apps
  module BusinessRegisterApp
    class ActsSubmissionForm
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor(
        :email,
        :acts,
        :business_cin,
        :business_name,
        :business_address,
        :business_section,
        :business_insertion,
        :business_court,
      )

      def acts=(array)
        @acts = array.map do |act|
          Act.new(act)
        end
      end

      def encoded_note
        Base64.encode64(note.to_s)
      end

      private

      def note
        {
          value: business_cin,
          text: business_name,
          title: business_address,
          descr: {
            oddiel: business_section.to_i,
            vlozka: business_insertion.to_i,
            sud: business_court.to_i
          }.to_json.to_s,
          name: business_name,
          code: business_cin
        }.to_json
      end

      class Act
        include ActiveModel::Model
        include ActiveModel::Validations

        attr_accessor(:id, :code, :name, :make_copy)
      end
    end
  end
end
