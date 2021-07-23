class CampusAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  def initialize(values, options = {})
    super(:campus, values, options)
  end

  def value_html
    Array(values).map do |value|
      location_string(CampusService.find(value))
    end.join("")
  end

  def campus_search_path(campus)
    CampusSearchHelper.path(campus)
  end

  private

    def attribute_value_to_html(value)
      loc = CampusService.find(value)
      li_value location_string(loc)
    end

   def location_string(loc)
     return unless loc
     content_tag(:a, loc.dig(:term), href: campus_search_path(loc))
   end

   class CampusSearchHelper
     include Rails.application.routes.url_helpers
     def self.path(campus)
       self.new.search_catalog_path(f: { campus_sim: [campus.dig(:id)] })
     end
   end
end
