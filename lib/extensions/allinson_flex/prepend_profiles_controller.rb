# frozen_string_literal: true
module Extensions
  module AllinsonFlex
    module PrependProfilesController
      # modified from allinson_flex to supply error feedback
      def import
        uploaded_io = params[:file]
        if uploaded_io.blank?
          redirect_to profiles_path, alert: 'Please select a file to upload'
          return
        end
 
        begin 
          @allinson_flex_profile = ::AllinsonFlex::Importer.load_profile_from_path(path: uploaded_io.path)
        rescue ::AllinsonFlex::Importer::YamlSyntaxError => e
          @validation_error = "Invalid YAML provided:<br/><br/>"
          @validation_error += e.message
        rescue ::AllinsonFlex::Validator::InvalidDataError
          default_schema = ::JSONSchemer.schema(::Pathname.new(::AllinsonFlex.m3_schema_path))
          data = ::YAML.load_file(uploaded_io.path)
          @validation_error = "Profile data failed schema validation.  See logs for full details of all errors.  Initial errors are:<br/><br/>"
          errors = default_schema.validate(data).to_a
          errors.each do |error|
            %w[type details data_pointer data schema_pointer schema].each do |key|
              @validation_error += "#{key.titleize}: #{error[key]}<br/>" if error[key].present?
            end
            @validation_error += "<br/>"
          end
        end
 
        if @validation_error.present?
          redirect_to profiles_path, alert: @validation_error.to_s.truncate(800)
        elsif @allinson_flex_profile.save
          redirect_to profiles_path, notice: 'AllinsonFlexProfile was successfully created.'
        else
          redirect_to profiles_path, alert: @allinson_flex_profile.errors.messages.to_s.truncate(800)
        end
      end
    end
  end
end
