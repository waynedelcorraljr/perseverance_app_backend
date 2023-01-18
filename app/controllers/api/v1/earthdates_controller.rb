class Api::V1::EarthdatesController < ApplicationController

    def index
        Photo.check_for_new
        earthdates = Earthdate.all
        render json: EarthdateSerializer.new(earthdates)
    end

end
