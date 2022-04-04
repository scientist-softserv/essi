module ESSI
  module IndexesSortableMetadata
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc[Solrizer.solr_name('sort_title',
                                    :stored_sortable,
                                    type: :string)] = object.try(:title)&.first.to_s
        solr_doc[Solrizer.solr_name('date_created',
                                    :stored_sortable,
                                    type: :integer)] = object.try(:date_created)&.first.to_i
      end
    end
  end
end
