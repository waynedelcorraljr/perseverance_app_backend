class Api::V1::EarthdatesController < ApplicationController

    def index
        earthdates = Earthdate.all
        render json: EarthdateSerializer.new(earthdates)
        self.check_for_new
    end

    def call_nasa_ed
        response = HTTParty.get("https://api.nasa.gov/mars-photos/api/v1/manifests/Perseverance/?api_key=#{ENV['NASA_KEY']}")
        ed_json_object_arr = response["photo_manifest"]["photos"]
    end

    def create_earthdates_from_api(ed_json_object_arr)
        ed_json_object_arr.each do |obj|
            Earthdate.create_with(total_photos: obj["total_photos"]).find_or_create_by(date: obj["earth_date"]).update_attributes(total_photos: obj["total_photos"])
        end
    end

end
