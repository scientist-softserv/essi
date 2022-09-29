# TODO Decide if we need this, or can use the stock Hyrax code, or the newer Hyrax code
module Extensions
  module Hyrax
    module WorkShowPresenter
      module ManifestMetadata
        # Copied from Hyrax gem
        # IIIF metadata for inclusion in the manifest
        #  Called by the `iiif_manifest` gem to add metadata
        #
        # @return [Array] array of metadata hashes
        def manifest_metadata
          metadata = []
          (static_iiif_metadata_fields | public_view_properties.keys).each do |field|
            next unless methods.include?(field.to_sym)
            if field.to_sym.in? (self.class.try(:custom_rendered_properties) || [])
              value = send(field, options: { iiif: true })
            else
              value = send(field)
            end

            next if value.blank?

            metadata << {
              'label' => label_for(field),
              'value' => Array.wrap(value)
            }
          end
          metadata
        end
 
        def static_iiif_metadata_fields
          ::Hyrax.config.iiif_metadata_fields
        end

        def public_view_properties
          @public_view_properties ||= dynamic_schema_service.view_properties.reject { |k,v| v[:admin_only] }
        end

        def label_for(field)
          public_view_properties.dig(field, :label) || I18n.t("simple_form.labels.defaults.#{field}", default: field.to_s.humanize)
        end
      end
    end
  end
end
