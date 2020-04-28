# Imported from Hyrax to modify for FileSet-backed branding images
class CollectionBrandingInfo < ApplicationRecord

  def initialize(collection_id:,
                 filename:,
                 role:,
                 alt_txt: "",
                 target_url: "")

    super()
    self.collection_id = collection_id
    self.role = role
    self.alt_text = alt_txt
    self.target_url = target_url

    self.local_path = find_local_filename(collection_id, role, filename)
  end

  def collection
    @collection ||= Collection.where(id: collection_id).first
  end

  def file_set
    @file_set ||= FileSet.find(file_set_id) if file_set_id.present?
  end

  def save(file_location, copy_file = true)
    local_dir = find_local_dir_name(collection_id, role)
    FileUtils.mkdir_p local_dir
    FileUtils.cp file_location, local_path unless file_location == local_path || !copy_file
    FileUtils.remove_file(file_location) if File.exist?(file_location) && copy_file
    super()
  end

  def delete(location_path)
    FileUtils.remove_file(location_path) if File.exist?(location_path)
  end

  def find_local_filename(collection_id, role, filename)
    local_dir = find_local_dir_name(collection_id, role)
    File.join(local_dir, filename)
  end

  def find_local_dir_name(collection_id, role)
    File.join(Hyrax.config.branding_path, collection_id.to_s, role.to_s)
  end

  def file
    File.split(local_path).last
  end

  def relative_path
    relative_path = "/" + local_path.split("/")[-4..-1].join("/")
  end

  def display_hash
    { file: file,
      full_path: local_path,
      relative_path: relative_path,
      file_location: relative_path,
      alttext: alt_text,
      linkurl: target_url }
  end
end
