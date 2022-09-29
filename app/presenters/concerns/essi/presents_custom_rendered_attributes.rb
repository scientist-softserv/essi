module ESSI
  module PresentsCustomRenderedAttributes
    CUSTOM_RENDERED_ATTRIBUTES = [:campus, :holding_location].freeze

    def self.included(base)
      base.class_eval do
        extend ClassMethods
      end
    end

    module ClassMethods
      # override allinson_flex delegation
      def delegated_properties
        (defined?(super) ? super : [] ) - CUSTOM_RENDERED_ATTRIBUTES
      end

      def custom_rendered_properties
        (defined?(super) ? super : [] ) + CUSTOM_RENDERED_ATTRIBUTES
      end
    end

    CUSTOM_RENDERED_ATTRIBUTES.each do |att|
      define_method(att) do |**keyword_args|
        options = keyword_args[:options] || {}
        custom_renderer = "#{att.to_s.titleize.gsub(' ', '')}AttributeRenderer".constantize.new(solr_document.send(att), options)
        custom_renderer.send(options[:iiif] ? :value_html : :render_dl_row)
      end
    end
  end
end
