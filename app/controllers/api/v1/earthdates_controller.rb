class Api::V1::EarthdatesController < ApplicationController

    def index
        self.create_earthdates_from_api
        earthdates = Earthdate.all
        render json: EarthdateSerializer.new(earthdates)
    end

    def create_earthdates_from_api
        response = HTTParty.get('https://api.nasa.gov/mars-photos/api/v1/manifests/Perseverance/?api_key=DEMO_KEY')
        ed_json_object_arr = response["photo_manifest"]["photos"]
        ed_json_object_arr.each do |obj|
            Earthdate.create_with(total_photos: obj["total_photos"]).find_or_create_by(date: obj["earth_date"])
        end
    end

end
