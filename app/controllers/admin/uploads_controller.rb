class Admin::UploadsController < Admin::AdminController
  # GET /admin/uploads
  def index
    if params[:prefix].present?
      @files = get_storage_objects(prefix: params[:prefix])
    else
      @files = get_storage_objects()
    end
  end

  # POST /admin/uploads
  def create
    file_name = params[:file_name]
    if file_name.blank? then
      redirect_to new_admin_upload_path, notice: 'Upload failed. Filename can\'t be blank.'
    elsif ActiveStorage::Blob.service.exist?(file_name) then
      redirect_to new_admin_upload_path, notice: 'Upload failed. File with name: ' + file_name + ' already exists.'
    else
      file = params[:file]
      blob = ActiveStorage::Blob.create_and_upload!(io: file, key: file_name, filename: file.original_filename)
      url = local_storage? ? file_name : blob.url.split('?').first
      redirect_to admin_uploads_path, notice: 'File ' + file_name + ' was successfully uploaded to: ' + url
    end
  end

  # DELETE /admin/uploads/1
  def destroy
    filename = params[:id] + '.' +  params[:format]
    if ActiveStorage::Blob.service.exist?(filename) then
      # TODO - delete reference from db
      ActiveStorage::Blob.service.delete(filename)
      redirect_to admin_uploads_path, notice: 'File was successfully deleted.'
    else
      redirect_to admin_uploads_path, notice: 'File was not found.'
    end
  end

  def local_storage?
    not ActiveStorage::Blob.service.respond_to? :bucket
  end

  def get_storage_objects(prefix: nil)
    if local_storage? then
      ActiveStorage::Blob.all
    else
      ActiveStorage::Blob.service.bucket.objects(prefix: prefix)
    end
  end
end
