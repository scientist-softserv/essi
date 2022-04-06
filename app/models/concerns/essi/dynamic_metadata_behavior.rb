# frozen_string_literal: true

module ESSI
  module DynamicMetadataBehavior
    extend ActiveSupport::Concern

    CUSTOM_PROPERTIES = { based_near: { class_name: Hyrax::ControlledVocabularies::Location } }.freeze

    class_methods do
      def late_add_property(name, properties)
        if CUSTOM_PROPERTIES.keys.include?(name)
          properties = CUSTOM_PROPERTIES[name].merge(properties)
        end
        super(name, properties)
      end
    end
  end
end
