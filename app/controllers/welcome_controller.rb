class WelcomeController < ApplicationController
    def index
        render :action => 'welcome/index'
    end
end
