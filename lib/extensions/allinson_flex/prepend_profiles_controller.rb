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
          errors = default_schema.validate(data).to_a
          details = errors.map do |error|
            %w[type details data_pointer data schema_pointer schema].map do |key|
              "#{key.titleize}: #{error[key]}<br/>" if error[key].present?
            end.join
          end
          set_validation_error(action: 'schema validation', details: details)
        rescue ::ActiveRecord::RecordInvalid => e
          set_validation_error(action: 'construction', details: e.to_s.split(', '))
        end
 
        if @validation_error.blank? && @allinson_flex_profile.save
          redirect_to profiles_path, notice: 'AllinsonFlexProfile was successfully created.'
        else
          set_validation_error(action: 'save', details: @allinson_flex_profile.errors.full_messages) if @validation_error.blank?
          redirect_to profiles_path, alert: @validation_error.to_s.truncate(800)
        end
      end

      # new logger
      def log
        add_breadcrumbs
        log_path = ESSI.config.dig(:essi, :metadata, :profile_log)
        @logs = File.exists?(log_path) ? File.read(log_path) : 'No logs available'
      end

      private

      def set_validation_error(action:, details:)
        @validation_error = "Profile data failed #{action}.  <a href=\"/profiles/log\">See logs for full details of all errors.</a>  Initial errors are:<br/><br/>"
        @validation_error += details.join("<br/>")
      end
    end
  end
end
