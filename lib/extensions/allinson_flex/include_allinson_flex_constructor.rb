# frozen_string_literal: true

module Extensions
  module AllinsonFlex
    module IncludeAllinsonFlexConstructor
      def self.included(base)
        base.class_eval do
          # modified from allinson_flex: log construction errors
          def self.find_or_create_from(profile_id:, data:, logger: default_logger)
            profile = ::AllinsonFlex::Profile.find(profile_id) unless profile_id.nil?
      
            # when loading from path, we need to create the profile
            # when loading from form data, we already have the profile
            if profile.blank?
              profile = ::AllinsonFlex::Profile.new(
                profile: data,
                profile_version: data.dig('profile', 'version'),
                m3_version: data.dig('m3_version')
              )
            end
            profile.responsibility = data.dig('profile', 'responsibility')
            profile.responsibility_statement = data.dig('profile', 'responsibility_statement')
            profile.date_modified = data.dig('profile', 'date_modified')
            profile.profile_type = data.dig('profile', 'type')
      
            construct_profile_contexts(profile: profile)
            log_profile_construction_errors(profile: profile, logger: logger)
            profile.save!
            logger.info(%(LoadedAllinsonFlex::Profile ID=#{profile.id}))
            create_dynamic_schemas(profile: profile, logger: logger)
            profile
          end

          # modified from allinson_flex: log construction errors
          def self.create_dynamic_schemas(profile:, logger: default_logger)
            profile = construct_default_dynamic_schemas(profile: profile)
            profile = construct_dynamic_schemas(profile: profile)
            log_profile_construction_errors(profile: profile, logger: logger)
            profile.save!
            logger.info(%(Created AllinsonFlex::Context and AllinsonFlex::DynamicSchema objects for ID=#{profile.id}))
          end

          # essi method for logging errors
          def self.log_profile_construction_errors(profile:, logger: default_logger)
            unless profile.valid?
              profile.errors.full_messages.each_with_index do |message, index|
                logger.error "Profile error #{index+1} of #{profile.errors.full_messages.count}: #{message}"
              end
            end
          end

          # modified from allinson_flex: property texts built in separate method
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
   
              construct_profile_property_texts(key: 'display_label', name: name, property: property, properties_hash: properties_hash, profile_context: profile_context, profile_class: profile_class, logger: logger)
              construct_profile_property_texts(key: 'usage_guidelines', name: name, property: property, properties_hash: properties_hash, profile_context: profile_context, profile_class: profile_class, logger: logger)
    
              property
            end
          end

          # new method for building property texts
          # modified to handle optional keys, possibly absent from properties_hash
          def self.construct_profile_property_texts(key:, name:, property:, properties_hash:, profile_context:, profile_class:, logger: default_logger)
            return unless properties_hash.dig(name, key)&.any?

            property_text = property.texts.build(
              name: key,
              value: properties_hash.dig(name, key, 'default')
            )

            logger.info(%(Constructed AllinsonFlex::ProfileText "#{property_text.value}" for AllinsonFlex::ProfileProperty "#{property.name}"))

            [profile_context, profile_class].each do |textable|
              if properties_hash.dig(name, key).keys.include? textable.name
                property_text = property.texts.build(
                  name: key,
                  value: properties_hash.dig(name, key, textable.name),
                  textable: textable
                )
                logger.info(%(Constructed AllinsonFlex::ProfileText "#{property_text.value}" for AllinsonFlex::ProfileProperty "#{property.name} on #{textable.name}"))
              end
            end
          end
    
          # modified from allinson_flex: includes usage_guidelines
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
                      'usage_guidelines' => display_value('usage_guidelines', property, klass, context),
                      'required' => required?(property.cardinality_minimum),
                      'singular' => singular?(property.cardinality_maximum),
                      'indexing' => property.indexing
                    }.compact
                  }.compact
                end.inject(:merge)
            }
          end
    
          # modified from allinson_flex: uses new helper method
          def self.display_label(property, klass, context = nil)
            display_value('display_label', property, klass, context)
          end

          # new method: abstracted display value lookup
          def self.display_value(name, property, klass, context = nil)
            if context.present?
              context_label = context.context_texts.detect { |t| t.value if t.name == name && t.profile_property_id == property.id }&.value
              return context_label unless context_label.blank?
            end
            class_label = klass.class_texts.detect { |t| t.value if t.name == name && t.profile_property_id == property.id }&.value
            return class_label unless class_label.blank?
            property.texts.map { |t| t.value if t.name == name && t.textable_type.nil? }.compact.first
          end
        end
      end
    end
  end
end
