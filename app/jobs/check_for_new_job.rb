class CheckForNewJob < ApplicationJob
  queue_as :default

  def perform(*args)
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
end
