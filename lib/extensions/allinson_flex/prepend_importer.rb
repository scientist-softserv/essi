# frozen_string_literal: true

module Extensions
  module AllinsonFlex
    module PrependImporter
      # unmodified from allinson_flex
      def validate!
        validator.validate(data: data, schema: schema, logger: logger)
      end
    end
  end
end
