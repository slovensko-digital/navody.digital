module ActiveStorageBlobInitializer
  extend ActiveSupport::Concern

  included do
    has_one_attached :signed_blob

    def signed?
      metadata[:signed] || signed_blob.attached?
    end

    # Returns either self if the current blob is signed, or the signed blob (if exists)
    def get_signed_blob
      if metadata[:signed]
        self
      elsif signed_blob.attached?
        signed_blob
      end
    end

    # If the signature is required, return signed version of this blob, otherwise the blob itself
    def blob_for_upvs
      metadata[:signed_required] ? get_signed_blob : self
    end
  end
end

ActiveSupport::Reloader.to_prepare do
  ActiveSupport.on_load(:active_storage_blob) do
    include ActiveStorageBlobInitializer
  end
end
