module Extensions
  module IIIFManifest
    module ManifestBuilder
      module ImageBuilder
        module ViewingHint
          # modified from iiif_manifest to include viewing_hint
          def apply(canvas, viewing_hint: nil)
            canvas['viewingHint'] = viewing_hint if viewing_hint.present?
            super(canvas)
          end
        end
      end
    end
  end
end
