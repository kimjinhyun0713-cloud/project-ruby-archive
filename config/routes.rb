Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  scope path: "tech" do
    get "/", to: "tech#index", as: :tech_index
    resources :posts
    resources :projects
    resources :tools
  end
  
  resources :news, only: [ :index, :show ]
  scope path: "research" do
    get "/", to: "research#index", as: :research_index
    resources :notes
    resources :papers
  resources :translators, only: [:index, :create]
  end
end
