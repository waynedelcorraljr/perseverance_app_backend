class Photo < ApplicationRecord
    belongs_to :earthdate

    def self.check_for_new
        @earthdates ||= Earthdate.call_nasa_for_earthdates
        total_days_on_api = @earthdates&.[]('photo_manifest')&.[]('photos').size
        total_days_in_db = Earthdate.all.size
        last_photo_earthdate = Photo.all.last.earth_date.to_datetime

        if total_days_in_db < total_days_on_api && @earthdates
            Earthdate.create_earthdates_from_api(@earthdates)
            starting_index = total_days_on_api - (total_days_on_api - total_days_in_db)
            new_photos = call_nasa_for_photos(starting_index)
            create_photos_from_api(new_photos)
        elsif last_photo_earthdate && last_photo_earthdate < Earthdate.last.date.to_datetime
            starting_index = Earthdate.all.pluck(:date).index(last_photo_earthdate)
            new_photos = call_nasa_for_photos(starting_index)
            create_photos_from_api(new_photos)
        end
    end

    def self.call_nasa_for_photos(starting_index)
        @dates_arr = Earthdate.all.pluck(:date)[starting_index..-1]

        photos_arr = []
        @dates_arr.each do |date|
            response = HTTParty.get(
              "https://api.nasa.gov/mars-photos/api/v1/rovers/perseverance/photos?earth_date=#{date}&api_key=#{ENV['NASA_KEY']}"
            )
            photos_arr << response["photos"]
        end
        photos_arr
    end

    def self.create_photos_from_api(photos_arr)
        id_arr = Earthdate.all.pluck(:id)
        dates_arr = Earthdate.all.pluck(:date)

        photos_arr.each do |day_arr|
            day_arr.each do |p|
                Photo.create_with(likes: 0).
                  find_or_create_by(sol: p["sol"], status: p["rover"]["status"], img_src: p["img_src"], earth_date: p["earth_date"], earthdate_id: id_arr[dates_arr.find_index(p["earth_date"])])
            end
        end
    end
end
