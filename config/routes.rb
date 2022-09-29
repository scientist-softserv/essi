require 'sidekiq/web'

Rails.application.routes.draw do


  mount Bulkrax::Engine, at: '/'
  # new route for allinson_flex
  scope module: 'allinson_flex' do
    resources :profiles, only: [] do
      collection do
        get '/log', action: :log, as: :log
      end
    end
  end
  mount AllinsonFlex::Engine, at: '/'
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  # mount spec/javascripts/fixtures directory
  mount JasmineFixtureServer => '/spec/javascripts/fixtures' if defined?(Jasmine::Jquery::Rails::Engine)

  concern :iiif_search, BlacklightIiifSearch::Routes.new
        mount BrowseEverything::Engine => '/browse'

  mount Riiif::Engine => 'iiif/2', as: :riiif if Hyrax.config.iiif_image_server?

  # block Blacklight bookmark routes
  get '/bookmarks', to: 'application#rescue_404'
  post '/bookmarks', to: 'application#rescue_404'
  get '/bookmarks/*all', to: 'application#rescue_404'
  post '/bookmarks/*all', to: 'application#rescue_404'

  mount Blacklight::Engine => '/'
  mount Hydra::RoleManagement::Engine => '/'

    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, controllers: { sessions: 'users/sessions', omniauth_callbacks: "users/omniauth_callbacks" }, skip: [:passwords, :registration]
  devise_scope :user do
    get('global_sign_out',
        to: 'users/sessions#global_logout',
        as: :destroy_global_session)
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
    get 'users/auth/cas', to: 'users/omniauth_authorize#passthru', defaults: { provider: :cas }, as: "new_user_session"
    get 'sign_in_as', to: 'users/sessions#become', as: :sign_in_as
    get 'users/sessions/log_in_as', to: 'users/sessions#log_in_as', as: :log_in_as
  end
  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  namespace :hyrax, path: :concern do
    resources :paged_resources, only: [] do
      member do
        get :structure
        post :structure, action: :save_structure
        get '/pdf', action: :pdf, as: :pdf
      end
    end
    resources :archival_materials, only: [] do
      member do
        get :structure
        post :structure, action: :save_structure
        get '/pdf', action: :pdf, as: :pdf
      end
    end
    resources :file_sets, only: [] do
      member do
        post :regenerate_ocr, action: :regenerate_ocr
      end
    end
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
    concerns :iiif_search
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  authenticate :user, lambda { |u| u.ability.can?(:manage, :sidekiq_dashboard) } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Switch routes must come before wildcard route
  get 'switch_user', to: 'switch_user#set_current_user'
  get 'switch_user/remember_user', to: 'switch_user#remember_user'

  # Purl redirects
  get '/purl/formats/:id', to: 'purl#formats', as: 'formats_purl'
  get '/purl/*id', to: 'purl#default', as: 'default_purl'

  # Send ActionController::RoutingError to 404 page
  # Must be the last route defined
  match '*unmatched', to: 'application#rescue_404', via: :all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
