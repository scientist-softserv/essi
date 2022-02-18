# NameError: uninitialized constant Hyrax::SearchState
require 'hyrax/search_state'

class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  skip_after_action :discard_flash_if_xhr
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'
  protect_from_forgery with: :exception

  before_action do
    if current_user && current_user.admin?
      Rack::MiniProfiler.authorize_request
    end
  end

  rescue_from ActionController::UnknownFormat, with: :rescue_404
  def rescue_404
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
