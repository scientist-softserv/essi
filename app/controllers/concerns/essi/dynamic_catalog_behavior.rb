# modified from allinson_flex with admin_only check
module ESSI
  module DynamicCatalogBehavior
    extend ActiveSupport::Concern

    class_methods do
      def load_allinson_flex
        profile = AllinsonFlex::Profile.current_version
        unless profile.blank?
          profile.properties.each do |prop|
            # blacklight wants 1 label for all classes with this property
            # therefor we need to use the default label
            label = prop.texts.map { |t| t.value if t.name == 'display_label' && t.textable_type.nil? }.compact.first
            if prop.indexing.include?("stored_searchable")
              index_args = {
                itemprop: prop.name,
                label: label
              }

              if prop.indexing.include?("admin_only")
                index_args[:if] = lambda { |context, _field_config, _document| context.try(:current_user)&.admin? }
              end

              # @fixme this does not seem to have the intended effect
              if prop.indexing.include?("facetable")
                index_args[:link_to_facet] = solr_name(prop.name.to_s, :facetable)
              end

              name = solr_name(prop.name.to_s, :stored_searchable)
              unless blacklight_config.index_fields[name].present?
                blacklight_config.add_index_field(name, index_args)
              end
            end

            if prop.indexing.include?("facetable")
              name = solr_name(prop.name.to_s, :facetable)
              facet_args = { label: label }
              if prop.indexing.include?("admin_only")
                facet_args[:if] = lambda { |context, _field_config, _document| context.try(:current_user)&.admin? }
              end
              unless blacklight_config.facet_fields[name].present?
                blacklight_config.add_facet_field(name, **facet_args)
              end
            end
          end
        end
      end
    end

    def initialize(skip_allinson_flex: false)
      self.class.load_allinson_flex unless skip_allinson_flex
      super()
    end
  end
end
