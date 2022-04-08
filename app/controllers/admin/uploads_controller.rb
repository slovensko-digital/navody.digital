class Admin::UploadsController < Admin::AdminController
  # GET /admin/uploads
  def index
    @files = UploadsService.find_files(prefix: params[:prefix])
  end

  # POST /admin/uploads
  def create
    file = params[:file]
    file_name = params[:file_name].presence || file.original_filename
    file_name.gsub!(/[.](?=.*[.])/, '_')

    if ActiveStorage::Blob.service.exist?(file_name)
      redirect_to new_admin_upload_path, notice: 'Upload failed. File with name: ' + file_name + ' already exists.'
    else
      blob = ActiveStorage::Blob.create_and_upload!(io: file, key: file_name, filename: file_name)
      url = UploadsService.get_url_for_blob(blob)
      redirect_to admin_uploads_path, notice: 'File ' + file_name + ' was successfully uploaded to: ' + url
    end
  end

  # DELETE /admin/uploads/1
  def destroy
    filename = params[:format] ? params[:id] + '.' +  params[:format] : params[:id]

    if ActiveStorage::Blob.service.exist?(filename)
      UploadsService.delete_file(filename)
      redirect_to admin_uploads_path, notice: 'File was successfully deleted.'
    else
      redirect_to admin_uploads_path, notice: 'File was not found.'
    end
  end
end
