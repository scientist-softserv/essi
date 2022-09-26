# modified from iiif_manifest to avoid double inclusion of description property
module Extensions
  module IIIFManifest
    module ManifestBuilder
      module RecordPropertyBuilder
        module DynamicDescription
          def apply(manifest)
            manifest['@id'] = record.manifest_url.to_s
            manifest.label = record.to_s
            manifest.description = record.description unless dynamic_description?(manifest)
            manifest.viewing_hint = viewing_hint if viewing_hint.present?
            manifest.viewing_direction = viewing_direction if viewing_direction.present?
            manifest.metadata = record.manifest_metadata if valid_metadata?
            manifest.service = services if search_service.present?
            manifest
          end

          def dynamic_description?(manifest)
            record.public_view_properties.keys.include?(:description)
          end
        end
      end
    end
  end
end
