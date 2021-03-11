class Api::V1::PhotosController < ApplicationController

    def index
        self.create_photos_from_api
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
        dates_arr.each do |date|
            response = HTTParty.get("https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?earth_date=#{date}&api_key=DEMO_KEY")
            photos_arr = response["photos"]
            # byebug
            photos_arr.each do |p|
                # ed_id = Earthdate.find_by(date: p["earth_date"]).id
                # Photo.create_with(sol: p["sol"], status: p["status"], earth_date: p["earth_date"], earthdate_id: ed_id).find_or_create_by(img_src: p["img_src"])
            end
        end  
    end
    
    private

    def photo_params
        params.require(:photo).permit(:sol, :status, :img_src, :earth_date, :earthdate_id)
    end


end
