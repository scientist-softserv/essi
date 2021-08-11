# frozen_string_literal: true

module Extensions
  module AllinsonFlex
    module IncludeAllinsonFlexConstructor
      def self.included(base)
        base.class_eval do
          # unmodified from allinson_flex
          def self.construct_profile_properties(profile:, profile_context:, profile_class:, logger: default_logger)
            properties_hash = profile.profile.dig('properties')
    
            properties_hash.keys.each do |name|
              property = profile.properties.build(
                name: name,
                property_uri: properties_hash.dig(name, 'property_uri'),
                cardinality_minimum: properties_hash.dig(name, 'cardinality', 'minimum'),
                cardinality_maximum: properties_hash.dig(name, 'cardinality', 'maximum'),
                indexing: properties_hash.dig(name, 'indexing')
              )
              logger.info(%(Constructed AllinsonFlex::ProfileProperty "#{property.name}"))
    
              context = properties_hash.dig(name, 'available_on', 'context')
              # TODO ALL goes here?
              property.available_on_contexts << profile_context if context.blank? || context.include?(profile_context.name)
    
              classes = properties_hash.dig(name, 'available_on', 'class')
              property.available_on_classes << profile_class if classes.blank? || classes.include?(profile_class.name)
    
              property_text = property.texts.build(
                name: 'display_label',
                value: properties_hash.dig(name, 'display_label', 'default')
              )
    
              logger.info(%(Constructed AllinsonFlex::ProfileText "#{property_text.value}" for AllinsonFlex::ProfileProperty "#{property.name}"))
    
              if properties_hash.dig(name, 'display_label').keys.include? profile_context.name
                property_text = property.texts.build(
                  name: 'display_label',
                  value: properties_hash.dig(name, 'display_label', profile_context.name),
                  textable: profile_context
                )
                logger.info(%(Constructed AllinsonFlex::ProfileText "#{property_text.value}" for AllinsonFlex::ProfileProperty "#{property.name} on #{profile_context.name}"))
              end
    
              if properties_hash.dig(name, 'display_label').keys.include? profile_class.name
                property_text = property.texts.build(
                  name: 'display_label',
                  value: properties_hash.dig(name, 'display_label', profile_class.name),
                  textable: profile_class
                )
                logger.info(%(Constructed AllinsonFlex::ProfileText "#{property_text.value}" for AllinsonFlex::ProfileProperty "#{property.name}" on #{profile_class.name}))
              end
    
              property
            end
          end
    
          # unmodified from allinson_flex
          def self.build_schema(klass, context = nil)
            {
              'type' => klass.schema_uri || "http://example.com/#{klass.name}",
              'display_label' => klass.display_label,
              'properties' =>
                intersection_properties(klass, context).map do |property|
                  {
                    property.name => {
                      'predicate' => property.property_uri,
                      'display_label' => display_label(property, klass, context),
                      'required' => required?(property.cardinality_minimum),
                      'singular' => singular?(property.cardinality_maximum),
                      'indexing' => property.indexing
                    }.compact
                  }.compact
                end.inject(:merge)
            }
          end
    
          # unmodified from allinson_flex
          def self.display_label(property, klass, context = nil)
            if context.present?
              context_label = context.context_texts.detect { |t| t.value if t.name == 'display_label' && t.profile_property_id == property.id }&.value
              return context_label unless context_label.blank?
            end
            class_label = klass.class_texts.detect { |t| t.value if t.name == 'display_label' && t.profile_property_id == property.id }&.value
            return class_label unless class_label.blank?
            property.texts.map { |t| t.value if t.name == 'display_label' && t.textable_type.nil? }.compact.first
          end
        end
      end
    end
  end
end
