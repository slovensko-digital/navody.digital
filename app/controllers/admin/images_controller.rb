class Admin::ImagesController < Admin::AdminController

  # GET /admin/images
  def index
    if params[:prefix].present?
      @images = ActiveStorage::Blob.service.bucket.objects(prefix: params[:prefix])
    else
      @images = ActiveStorage::Blob.service.bucket.objects
    end
  end

  # GET /admin/images/1/edit
  def edit
  end

  # POST /admin/images
  def create
    picture_name = params[:picture_name]
    if ActiveStorage::Blob.service.exist?(picture_name) then
      redirect_to new_admin_image_path, notice: 'Upload failed. Image with name' + picture_name + ' already exists.'
    else
      file = params[:picture]
      blob = ActiveStorage::Blob.create_and_upload!(io: file, key: picture_name, filename: file.original_filename)

      url = ActiveStorage::Blob.service.bucket.url + '/' + picture_name
      redirect_to new_admin_image_path, notice: 'Image ' + picture_name + ' was successfully uploaded to: ' + url
    end
  end

  # PATCH/PUT /admin/images/1
  def update
    puts 'update'
    puts @image
    # puts @image.key
    # if @image.update(image_params)
    #   redirect_to admin_images_path, notice: 'Image was successfully updated.'
    # else
    #   render :edit
    # end
  end

  # DELETE /admin/images/1
  def destroy
    filename = params[:id] + '.' +  params[:format]
    if ActiveStorage::Blob.service.exist?(filename) then
      puts 'deleting ' + filename
      ActiveStorage::Blob.service.bucket.delete_objects(delete: {objects: [{key: filename}]})
      redirect_to admin_images_path, notice: 'Image was successfully destroyed.'
    else
      redirect_to admin_images_path, notice: 'Image was not found.'
    end
  end
end
