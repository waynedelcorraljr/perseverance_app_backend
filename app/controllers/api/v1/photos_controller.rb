class Api::V1::PhotosController < ApplicationController

    def index
        self.create_photos_from_api
        # Photo.all.destroy_all
        photos = Photo.all
        # render json: photos
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

    
    def create_photos_from_api
        dates_arr = Earthdate.all.map { |ed| ed.date }
        id_arr = Earthdate.all.map { |ed| ed.id }
        photos_arr = []
        dates_arr.each do |date|
            response = HTTParty.get("https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?earth_date=#{date}&api_key=YgYRZocaHcuFq1XghF8eUHRWv3vsK6uRiTMJX1nR")
            photos_arr << response["photos"]
        end  

        photos_arr.each do |day_arr|
            day_arr.each do |p|
                new_photo = Photo.where(sol: p["sol"], status: p["rover"]["status"], img_src: p["img_src"], earth_date: p["earth_date"]).first_or_initialize
                new_photo.earthdate_id = id_arr[dates_arr.find_index(new_photo.earth_date)]
                new_photo.save
            end
        end
        # byebug
    end
    
    private

    def photo_params
        params.require(:photo).permit(:sol, :status, :img_src, :earth_date, :earthdate_id)
    end


end
