class ApplicationController < ActionController::API
    def call_nasa
        dates_arr = Earthdate.all.map { |ed| ed.date }
        photos_arr = []
        dates_arr.each do |date|
            response = HTTParty.get("https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?earth_date=#{date}&api_key=#{ENV['NASA_KEY']}")
            photos_arr << response["photos"]
        end
        photos_arr
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

    def check_max_ed
        response = HTTParty.get("https://api.nasa.gov/mars-photos/api/v1/manifests/Perseverance/?api_key=#{ENV['NASA_KEY']}")
        if response["photo_manifest"]["photos"]
            ed_json_object_arr = response["photo_manifest"]["photos"]
            ed_json_object_arr.length
        else
            Earthdate.all.length
        end
    end

    def check_for_new
        if Earthdate.all.length < self.check_max_ed
            nasa = self.call_nasa_ed
            self.create_earthdates_from_api(nasa)
            new_photos = self.call_nasa
            self.create_photos_from_api(new_photos)
        end
    end

end
