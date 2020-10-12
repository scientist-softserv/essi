module OsdModalHelper
  def osd_modal_for(image_presenter, &block)
    if !image_presenter
      block.call
    else
      modal_manifest = image_presenter.display_image&.iiif_endpoint&.url
      if modal_manifest
        modal_manifest += '/info.json' unless modal_manifest.match 'info.json'
        content_tag :span, class: 'ignore-select', data: { modal_manifest: modal_manifest }, &block
      else
        content_tag :span, class: 'ignore-select', &block
      end
    end
  end
end
