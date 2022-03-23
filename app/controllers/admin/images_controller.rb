class Admin::ImagesController < Admin::AdminController
  def create
      file = params[:picture]
      picture_name = params[:picture_name]
      blob = ActiveStorage::Blob.create_and_upload!(io: file, key: picture_name, filename: file.original_filename)

      # puts blob.url
      url =  ActiveStorage::Blob.service.bucket.url + "/" + blob.key
      url = '<a href="' + url + '">' + url + '<a>'

      redirect_to admin_images_path, notice: 'Image ' + picture_name + ' was successfully uploaded.'
  end
end
