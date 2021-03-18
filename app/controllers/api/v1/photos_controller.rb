class Api::V1::PhotosController < ApplicationController

    def index
        self.check_for_new
        photos = Photo.all
        render json: PhotoSerializer.new(photos)
    end
    
    def update
        # byebug
        photo = Photo.find_by(id: params[:id])
        if params[:photo][:likes] == "empty" # "empty" implies empty like button has been pressed.
            photo.update(likes: photo.likes += 1)
        else
            photo.update(likes: photo.likes -= 1)
        end
    end


end
