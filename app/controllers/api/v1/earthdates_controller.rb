class Api::V1::EarthdatesController < ApplicationController

    def index
        nasa = self.call_nasa_ed
        self.create_earthdates_from_api(nasa)
        earthdates = Earthdate.all
        render json: EarthdateSerializer.new(earthdates)
    end

    def call_nasa_ed
        response = HTTParty.get('https://api.nasa.gov/mars-photos/api/v1/manifests/Perseverance/?api_key=DEMO_KEY')
        ed_json_object_arr = response["photo_manifest"]["photos"]
    end

    def create_earthdates_from_api(ed_json_object_arr)
        ed_json_object_arr.each do |obj|
            Earthdate.find_or_create_by(date: obj["earth_date"], total_photos: obj["total_photos"])
        end
    end

end
