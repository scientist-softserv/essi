module Extensions
  module Hyrax
    module Forms
      module CollectionForm
        module FileSetBackedBranding

          delegate :banner_branding, :logo_branding, to: :model

          def banner_info
            @banner_info ||= (banner_branding.first&.display_hash || {})
          end
    
          def logo_info
            @logo_info ||= logo_branding.map(&:display_hash)
          end
        end
      end
    end
  end
end
