Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
root 'welcome#index'

namespace :api do
  namespace :v1 do
    resources :photos, only: [:index, :update]
    resources :earthdates, only: [:index]
  end
end



end
