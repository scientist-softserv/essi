IiifPrint.config do |config|
  # NOTE: WorkTypes and models are used synonymously here.
  # Add models to be excluded from search so the user
  # would not see them in the search results.
  # by default, use the human readable versions like:
  # @example
  #   # config.excluded_model_name_solr_field_values = ['Generic Work', 'Image']
  #
  # config.excluded_model_name_solr_field_values = []

  # Add configurable solr field key for searching,
  # default key is: 'human_readable_type_sim'
  # if another key is used, make sure to adjust the
  # config.excluded_model_name_solr_field_values to match
  # @example
  #   config.excluded_model_name_solr_field_key = 'some_solr_field_key'

  config.uv_config_path = "/uv/uv_config.json"

  config.child_work_attributes_function = lambda do |parent_work:, admin_set_id:|
    {
      admin_set_id: admin_set_id.to_s,
      creator: parent_work.creator.to_a,
      # adding this configuration because IIIF Print is expecting rights_statement
      # to be an array but it is a string in ESSI
      rights_statement: parent_work.rights_statement.to_s,
      visibility: parent_work.visibility.to_s
    }
  end

  # Configure how the manifest sorts the canvases, by default it sorts by :title,
  # but a different model property may be desired such as :date_published
  # @example
  #   config.sort_iiif_manifest_canvases_by = :date_published
  config.uv_config_path = '/uv/uv_config.json'

  config.ocr_coords_from_json_function = lambda do |document:, **|
    document['word_boundary_tsi']
  end

  config.all_text_generator_function = lambda do |object:|
    IiifPrint::TextExtraction::AltoReader.new(object.extracted_text.content).text if object.extracted_text.present?
  end

  config.iiif_metadata_field_presentation_order = Hyrax.config.iiif_metadata_fields
end
