class CampusAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  def initialize(values, options = {})
    super(:campus, values, options)
  end

  # exclude campus value from display in favor of CampusCollectionBreadcrumbRenderer
  def value_html
    ''
  end
end
