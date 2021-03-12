class Api::V1::PhotosController < ApplicationController

    def index
        if Earthdate.all.length < self.check_max_ed || Photo.all.length === 0
            new_stuff = self.call_nasa
            self.create_photos_from_api(new_stuff)
        end
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

    def call_nasa
        dates_arr = Earthdate.all.map { |ed| ed.date }
        photos_arr = []
        dates_arr.each do |date|
            response = HTTParty.get("https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?earth_date=#{date}&api_key=YgYRZocaHcuFq1XghF8eUHRWv3vsK6uRiTMJX1nR")
            photos_arr << response["photos"]
        end
        photos_arr
    end

    def check_max_ed
        response = HTTParty.get('https://api.nasa.gov/mars-photos/api/v1/manifests/Perseverance/?api_key=DEMO_KEY')
        ed_json_object_arr = response["photo_manifest"]["photos"]
        ed_json_object_arr.length
    end

    def create_photos_from_api(photos_arr)
        dates_arr = Earthdate.all.map { |ed| ed.date }
        id_arr = Earthdate.all.map { |ed| ed.id }
          
        photos_arr.each do |day_arr|
            day_arr.each do |p|
                Photo.create_with(likes: 0).find_or_create_by(sol: p["sol"], status: p["rover"]["status"], img_src: p["img_src"], earth_date: p["earth_date"], earthdate_id: id_arr[dates_arr.find_index(p["earth_date"])])
            end
        end
    end
    
    private

    def photo_params
        params.require(:photo).permit(:sol, :status, :img_src, :earth_date, :earthdate_id)
    end


end
