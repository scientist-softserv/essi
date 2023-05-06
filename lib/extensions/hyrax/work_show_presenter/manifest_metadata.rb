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
          # Using IIIF Print's approach to display parent metadata
          iiif_manifest_presenter = ::Hyrax::IiifManifestPresenter.new(self)
          iiif_manifest_presenter.ability = current_ability
          iiif_manifest_presenter.manifest_metadata
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
