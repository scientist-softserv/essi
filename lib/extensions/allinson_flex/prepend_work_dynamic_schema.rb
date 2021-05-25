# frozen_string_literal: true

module Extensions
  module AllinsonFlex
    module PrependWorkDynamicSchema
      # unmodified method from allinson_flex, exhibiting issue #61
      def dynamic_schema
        @dynamic_schema ||= ::AllinsonFlex::DynamicSchema.find_by_id(id: self.dynamic_schema_id) || self.dynamic_schema_service(update: true)&.dynamic_schema
      end
    end
  end
end
