class Admin::UploadsController < Admin::AdminController
  # GET /admin/uploads
  def index
    if params[:prefix].present?
      @files = ActiveStorage::Blob.service.bucket.objects(prefix: params[:prefix])
    else
      @files = ActiveStorage::Blob.service.bucket.objects
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
      url = ActiveStorage::Blob.service.bucket.url + '/' + file_name
      redirect_to admin_uploads_path, notice: 'File ' + file_name + ' was successfully uploaded to: ' + url
    end
  end

  # DELETE /admin/uploads/1
  def destroy
    filename = params[:id] + '.' +  params[:format]
    if ActiveStorage::Blob.service.exist?(filename) then
      ActiveStorage::Blob.service.bucket.delete_objects(delete: {objects: [{key: filename}]})
      redirect_to admin_uploads_path, notice: 'File was successfully deleted.'
    else
      redirect_to admin_uploads_path, notice: 'File was not found.'
    end
  end
end
