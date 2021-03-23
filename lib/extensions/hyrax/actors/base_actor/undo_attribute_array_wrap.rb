# undo base Hyrax hard-coded of :license, :rights_statement as multi-valued
module Extensions
  module Hyrax
    module Actors
      module BaseActor
        module UndoAttributeArrayWrap
          private
            def apply_save_data_to_curation_concern(env)
              env.curation_concern.attributes = amended_clean_attributes(env)
              env.curation_concern.date_modified = ::Hyrax::TimeService.time_in_utc
            end

            def amended_clean_attributes(env)
              cleaned_attributes = clean_attributes(env.attributes)
              [:license, :rights_statement].each do |att|
                singularize_attribute!(cleaned_attributes, att) if singularize_attribute?(env, att, cleaned_attributes[att])
              end
              cleaned_attributes
            end
  
            def singularize_attribute?(env, att, value)
              value.is_a?(Array) && !env.curation_concern.class.properties.with_indifferent_access[att].multiple?
            end

            def singularize_attribute!(attributes, att)
              attributes[att] = attributes[att].first
            end
        end
      end
    end
  end
end
