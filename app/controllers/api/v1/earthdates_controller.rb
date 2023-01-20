class Api::V1::EarthdatesController < ApplicationController

    def index
        CheckForNewJob.perform_later
        earthdates = Earthdate.all
        render json: EarthdateSerializer.new(earthdates)
    end

end
