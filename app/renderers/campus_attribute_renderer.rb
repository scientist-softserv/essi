class CampusAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  def initialize(values, options = {})
    super(:campus, values, options)
  end

  # exclude campus value from catalog display in favor of CampusCollectionBreadcrumbRenderer
  def value_html
    options[:catalog] ? '' : attribute_value_to_html(Array.wrap(values).first)
  end

  private
    # campus display value for work show page, iiif metadata
    def attribute_value_to_html(value)
      CampusService.find(value)[:term]
    end
end
