module Extensions
  module IIIFManifest
    module ManifestBuilder
      module CanvasBuilder
        module ViewingHint
          private
            # modified from iiif_manifest to include viewing_hint
            def attach_image
              image_builder.new(display_image).apply(canvas, viewing_hint: record.viewing_hint)
            end
        end
      end
    end
  end
end
