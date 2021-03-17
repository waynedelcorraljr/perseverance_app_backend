class Api::V1::PhotosController < ApplicationController

    def index
        self.check_for_new
        photos = Photo.all
        render json: PhotoSerializer.new(photos)
    end

    # def create
    #     photo = Photo.new(photo_params)
    #     if photo.save
    #         render json: photo, status: :created
    #     else
    #         render json: { errors: photos.errors.full_messages}, status: :unprocessable_entity
    #     end
    # end
    
    def update
        # byebug
        photo = Photo.find_by(id: params[:id])
        if params[:photo][:likes] == "empty" # "empty" implies empty like button has been pressed.
            photo.update(likes: photo.likes += 1)
        else
            photo.update(likes: photo.likes -= 1)
        end
    end

    private

    def photo_params
        params.require(:photo).permit(:id, :sol, :status, :img_src, :earth_date, :earthdate_id)
    end


end
