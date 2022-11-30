module Extensions
  module IIIFManifest
    module ManifestBuilder
      module CanvasBuilder
        module ViewingHint
          private
            # unmodified from iiif_manifest
            def attach_image
              image_builder.new(display_image).apply(canvas)
            end
        end
      end
    end
  end
end
