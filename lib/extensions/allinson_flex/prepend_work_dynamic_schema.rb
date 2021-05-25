# frozen_string_literal: true

module Extensions
  module AllinsonFlex
    module PrependWorkDynamicSchema
      # @todo remove after issue is resolved within allinson_flex
      # modified from allinson_flex, to resolve issue #61
      def dynamic_schema
        @dynamic_schema ||= ::AllinsonFlex::DynamicSchema.find_by(id: self.dynamic_schema_id) || self.dynamic_schema_service(update: true)&.dynamic_schema
      end
    end
  end
end
