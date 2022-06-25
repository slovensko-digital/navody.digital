module Apps
  module BusinessRegisterApp
    class ActsSubmissionForm
      include ActiveModel::Model
      include ActiveModel::Validations

      attr_accessor(
        :email,
        :acts,
        :note,
        :business_ico,
        :business_name,
        :business_address,
      )

      def acts=(hash)
        @acts = hash.map do |_key, act|
          Act.new(act)
        end
      end

      class Act
        include ActiveModel::Model
        include ActiveModel::Validations

        attr_accessor(:id, :code, :name, :make_copy)
      end
    end
  end
end
