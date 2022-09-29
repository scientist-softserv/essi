class DescriptionAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  def initialize(value, options = {})
    super(:description, value, options)
  end

  def value_html
    safe_join(Array(values).map { |value| li_value(value) }, safe_join([tag(:br), tag(:br)], ''))
  end

  private

    def attribute_value_to_html(value)
      content_tag(:p, li_value(value))
    end
end
