# unmodified from iiif_manifest
module Extensions
  module IIIFManifest
    module ManifestBuilder
      module RecordPropertyBuilder
        module DynamicDescription
          def apply(manifest)
            manifest['@id'] = record.manifest_url.to_s
            manifest.label = record.to_s
            manifest.description = record.description
            manifest.viewing_hint = viewing_hint if viewing_hint.present?
            manifest.viewing_direction = viewing_direction if viewing_direction.present?
            manifest.metadata = record.manifest_metadata if valid_metadata?
            manifest.service = services if search_service.present?
            manifest
          end
        end
      end
    end
  end
end
