# frozen_string_literal: true

module Extensions
  module AllinsonFlex
    module PrependImporter
      # modified from allinson_flex to use a separate log
      def construct
        ::AllinsonFlex::AllinsonFlexConstructor.find_or_create_from(
          profile_id: profile_id,
          data: ::ActiveSupport::HashWithIndifferentAccess.new(data),
          logger: validation_logger
        )
      end

      # modified from allinson_flex to use a separate log
      def validate!
        validator.validate(data: data, schema: schema, logger: validation_logger)
      end

      def validation_logger
        @validation_logger ||= ::Logger.new(ESSI.config.dig(:essi, :metadata, :profile_log))
      end
    end
  end
end
