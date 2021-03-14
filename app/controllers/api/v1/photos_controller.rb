class Api::V1::PhotosController < ApplicationController

    def index
        self.check_for_new
        photos = Photo.all
        render json: PhotoSerializer.new(photos)
    end

    def create
        photo = Photo.new(photo_params)
        if photo.save
            render json: photo, status: :created
        else
            render json: { errors: photos.errors.full_messages}, status: :unprocessable_entity
        end
    end
    
    private

    def photo_params
        params.require(:photo).permit(:sol, :status, :img_src, :earth_date, :earthdate_id)
    end


end
