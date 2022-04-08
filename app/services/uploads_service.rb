class UploadsService

  def self.local_storage?
    !ActiveStorage::Blob.service.respond_to?(:bucket)
  end

  def self.find_files(prefix: nil)
    if local_storage?
      scope = ActiveStorage::Blob
      scope = scope.where('key ILIKE ?', "#{prefix}%") if prefix
      scope.all
    else
      ActiveStorage::Blob.service.bucket.objects(prefix: prefix)
    end
  end

  def self.get_url(file)
    if local_storage?
      Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
    else
      file.public_url
    end
  end

  def self.get_url_for_blob(blob)
    if local_storage?
      Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
    else
      blob.service.bucket.url + '/' + blob.key
    end
  end

  def self.delete_file(filename)
    if local_storage?
      ActiveStorage::Blob.find_by(key: filename).purge
    else
      ActiveStorage::Blob.find_by(key: filename).try(&:purge)
      ActiveStorage::Blob.service.delete(filename)
    end
  end
end
