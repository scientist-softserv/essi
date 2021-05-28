# frozen_string_literal: true
module Extensions
  module AllinsonFlex
    module PrependProfilesController
      # unmodified from allinson_flex
      def import
        uploaded_io = params[:file]
        if uploaded_io.blank?
          redirect_to profiles_path, alert: 'Please select a file to upload'
          return
        end
  
        @allinson_flex_profile = ::AllinsonFlex::Importer.load_profile_from_path(path: uploaded_io.path)
  
        if @allinson_flex_profile.save
          redirect_to profiles_path, notice: 'AllinsonFlexProfile was successfully created.'
        else
          redirect_to profiles_path, alert: @allinson_flex_profile.errors.messages.to_s
        end
      end
    end
  end
end
