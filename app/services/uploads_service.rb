class UploadsService
  class << self
    def local_storage?
      not ActiveStorage::Blob.service.respond_to? :bucket
    end

    def get_files(prefix: nil)
      if local_storage? then
          ActiveStorage::Blob.all
      else
          ActiveStorage::Blob.service.bucket.objects(prefix: prefix)
      end
    end
    
    def get_url(file)
      if local_storage? then
        Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      else
        file.public_url
      end
    end

    def get_url_for_blob(blob)
      if local_storage? then
        Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
      else
        blob.service.bucket.url + '/' + blob.key
      end
    end

    def delete_file(filename)
      if local_storage? then
        ActiveStorage::Blob.find_by(key: filename).purge
      else
        temp = ActiveStorage::Blob.find_by(key: filename)
        temp ? temp.purge : nil
        ActiveStorage::Blob.service.delete(filename)
      end
    end
  end
end
