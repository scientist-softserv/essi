# TODO Decide if we need this, or can use the stock Hyrax code, or the newer Hyrax code
module Extensions
  module Hyrax
    module WorkShowPresenter
      module ManifestMetadata
        HTML_RENDERED_FIELDS = [:holding_location].freeze
        # Copied from Hyrax gem
        # IIIF metadata for inclusion in the manifest
        #  Called by the `iiif_manifest` gem to add metadata
        #
        # @return [Array] array of metadata hashes
        def manifest_metadata
          metadata = []
          ::Hyrax.config.iiif_metadata_fields.each do |field|
            next unless methods.include?(field.to_sym)
            value = Array.wrap(send(field))
            if field.to_sym.in? HTML_RENDERED_FIELDS
              value.map! { |v| unrender_value(v) }
            end
      
            data = send(field)
            next if data.blank?
      
            metadata << {
              'label' => I18n.t("simple_form.labels.defaults.#{field}", default: field.to_s.humanize),
              'value' => value
            }
          end
          metadata
        end

        # retain br tags, sanitize all other HTML, remove label line
        def unrender_value(value)
          Array.wrap(ActionView::Base.full_sanitizer.sanitize(value.gsub(/<br\s*\/?>/, "\n")).split("\n")[1..-1]).join('<br>')
        end
      end
    end
  end
end
