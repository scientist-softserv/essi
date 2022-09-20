class CampusCollectionBreadcrumbRenderer < Hyrax::Renderers::AttributeRenderer
  attr_reader :main_app

  def initialize(value, main_app, options = {})
    @main_app = main_app
    super(:campus_collection_breadcrumb, value, options)
  end

  def value_html
    content_tag(:p,
                safe_join(values.map { |linkset| icon_and_breadcrumbs(linkset) },
                          tag(:br)))
  end

  private

    def icon_and_breadcrumbs(linkset)
      text_links = breadcrumbs(linkset)
      if linkset&.first&.[](:campus)
        safe_join([repository_icon, text_links], "")
      else
        text_links
      end
    end

    def breadcrumbs(linkset)
      safe_join(linkset.map { |link| link_for(link) }, " » ")
    end

    def link_for(hash)
      if hash[:campus]
        f = { campus_sim: [hash[:campus]]}
      elsif hash[:collection]
        f = { member_of_collection_ids_ssim: [hash[:collection]]}
      else
        f = {}
      end
      content_tag(:a, hash[:text], href: main_app.search_catalog_path(f: f))
    end

    def repository_icon
      ActionController::Base.helpers.image_tag('blacklight/repository.svg', class: 'blacklight-icons')
    end
end
