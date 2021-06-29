module ESSI
  module IndexesFilesets
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc['file_sets_ssim'] = object.file_sets.map(&:to_s)
      end
    end
  end
end
