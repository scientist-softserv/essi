class AddFileSetBackingToCollectionBrandingInfo < ActiveRecord::Migration[5.1]
  def change
    add_column :collection_branding_infos, :file_set_id, :string
    add_column :collection_branding_infos, :image_path, :string
  end
end
