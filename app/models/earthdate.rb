class Earthdate < ApplicationRecord
    has_many :photos

    def self.call_nasa_for_earthdates
        @response ||= HTTParty.get(
          "https://api.nasa.gov/mars-photos/api/v1/manifests/Perseverance/?api_key=#{ENV['NASA_KEY']}"
        )
    end

    def self.create_earthdates_from_api(ed_json_object_arr)
        ed_json_object_arr["photo_manifest"]["photos"].each do |obj|
            Earthdate.create_with(total_photos: obj["total_photos"]).
              find_or_create_by(date: obj["earth_date"]).
              update_attribute(:total_photos, obj["total_photos"])
        end
    end
end
