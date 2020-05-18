FactoryBot.define do
  factory :collection_branding_banner, class: CollectionBrandingInfo do
    transient do
      collection_id { '1' }
      filename { 'banner.png' }
      role { 'banner' }
      local_path { '/fake/path/to/banner.png' }
      alt_text { '' }
      target_url { '' }
      height { 0 }
      width { 0 }
      file_set_id { '1' }
      image_path { '/fake/path/to/image' }
    end
   initialize_with { CollectionBrandingInfo.new(collection_id: collection_id, filename: filename, role: role, alt_txt: alt_text, target_url: target_url, local_path: local_path, file_set_id: file_set_id, image_path: image_path) }
  end
  factory :collection_branding_logo, class: CollectionBrandingInfo do
    transient do
      collection_id { '1' }
      filename { 'logo.png' }
      role { 'logo' }
      local_path { '/fake/path/to/logo.png' }
      alt_text { 'This is the logo' }
      target_url { 'http://example.com/' }
      height { 0 }
      width { 0 }
      file_set_id { '1' }
      image_path { '/fake/path/to/image' }
    end
   initialize_with { CollectionBrandingInfo.new(collection_id: collection_id, filename: filename, role: role, alt_txt: alt_text, target_url: target_url, local_path: local_path, file_set_id: file_set_id, image_path: image_path) }
  end
end
