# frozen_string_literal: true

module Extensions
  module AllinsonFlex
    module PrependWorkDynamicSchema
      # @todo remove after issue is resolved within allinson_flex
      # modified from allinson_flex, to resolve issue #61
      def dynamic_schema
        @dynamic_schema ||= ::AllinsonFlex::DynamicSchema.find_by(id: self.dynamic_schema_id) || self.dynamic_schema_service(update: true)&.dynamic_schema
      end

      # @todo remove after issue is resolved within allinson_flex
      # method from allinson_flex, to resolve issue #63
      def initialize(attributes = nil, &_block)
        init_internals
        attributes = attributes.dup if attributes # can't dup nil in Ruby 2.3
        id = attributes && (attributes.delete(:id) || attributes.delete('id'))
        @ldp_source = build_ldp_resource(id)
        raise IllegalOperation, "Attempting to recreate existing ldp_source: `#{ldp_source.subject}'" unless ldp_source.new?
        self.dynamic_schema_id = attributes&.delete(:dynamic_schema_id)
        load_allinson_flex ## This is the new part
        assign_attributes(attributes) if attributes
        assert_content_model
        load_attached_files
  
        yield self if block_given?
        _run_initialize_callbacks
      end
  
    end
  end
end
