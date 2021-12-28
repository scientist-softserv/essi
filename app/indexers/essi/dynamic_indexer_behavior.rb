module ESSI
  module DynamicIndexerBehavior
    # Array-ify results of allinson_flex dynamic indexing
    def generate_solr_document
      solr_doc = super
      solr_doc.each do |key, value|
        if value.is_a? ActiveTriples::Relation
          solr_doc[key] = value.to_a
        end
      end
    end
  end
end
