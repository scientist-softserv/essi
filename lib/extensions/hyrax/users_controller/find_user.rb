# Modifies find_user alert
module Extensions
  module Hyrax
    module UsersController
      module FindUser
        private
          def find_user
            @user = ::User.from_url_component(params[:id])
            redirect_to root_path, alert: "User does not exist" unless @user
          end
      end
    end
  end 
end
