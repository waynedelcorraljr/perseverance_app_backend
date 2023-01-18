class WelcomeController < ApplicationController
    def index
      render json: Time.now.strftime('%m/%d/%Y @ %T')
    end
end
