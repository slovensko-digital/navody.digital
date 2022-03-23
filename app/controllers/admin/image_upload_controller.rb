class Admin::ImageUploadController < Admin::AdminController
    def index
    #   @user_journeys = UserJourney.all
    end
  
    def create
        file = params[:picture]
        picture_name = params[:picture_name]
        blob = ActiveStorage::Blob.create_and_upload!(io: file, key: picture_name, filename: file.original_filename)

        # puts blob.url
        url =  ActiveStorage::Blob.service.bucket.url + "/" + blob.key

        redirect_to admin_image_upload_index_path, notice: 'Image ' + picture_name + ' was successfully uploaded to: ' + url
    end

  end
  