# frozen_string_literal: true

module Extensions
  module AllinsonFlex
    module PrependImporter
      # modified from allinson_flex to use a separate log
      def validate!
        validator.validate(data: data, schema: schema, logger: validation_logger)
      end

      def validation_logger
        @validation_logger ||= Logger.new(Rails.root.join('log', 'profile_validation.log'), 10, 2.megabytes)
      end
    end
  end
end
