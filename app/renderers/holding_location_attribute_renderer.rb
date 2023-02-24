class HoldingLocationAttributeRenderer < Hyrax::Renderers::AttributeRenderer
  def initialize(value, options = {})
    super(:holding_location, value, options)
  end

  def value_html
    Array(values).map do |value|
      location_string(HoldingLocationService.find(value))
    end.join("")
  end

  private

    def attribute_value_to_html(value)
      loc = HoldingLocationService.find(value)
      li_value location_string(loc)
    end

    def location_string(loc)
      return unless loc.present?
      safe_join([label_string(loc), address_string(loc), contact_string(loc)].select(&:present?), tag(:br))
    end

    def label_string(loc)
      loc.dig(:label)
    end

    def address_string(loc)
      address_lines = [loc.dig(:address), loc.dig(:address2)]
      address_lines << safe_join([safe_join([loc.dig(:city),
                                            loc.dig(:state)].select(&:present?),
                                           ', '),
                                  loc.dig(:zip)].select(&:present?),
                                  ' ')
      safe_join(address_lines.select(&:present?), tag(:br))
    end

    def contact_string(loc)
      contact_hash = { mailto: loc.dig(:email),
                       tel: loc.dig(:phone) }.select { |k,v| v.present? }
      return nil if contact_hash.empty?
      contact_tags = contact_hash.map { |k,v| content_tag(:a, v, href: "#{k}:#{v}") }
      if contact_tags.size > 1
        contact_tags = contact_tags.zip([', ']).flatten.select(&:present?)
      end
      safe_join(['Contact at '] + contact_tags)
    end
end
