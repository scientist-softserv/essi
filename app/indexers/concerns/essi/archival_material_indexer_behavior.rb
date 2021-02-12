module ESSI
  module ArchivalMaterialIndexerBehavior

    # Add behaviors that make this work type unique

    # def generate_solr_document
    #   super.tap do |solr_doc|
    #     solr_doc[Solrizer.solr_name('number_of_pages',
    #                                 :stored_sortable,
    #                                 type: :integer)] = pages
    #     solr_doc[Solrizer.solr_name('number_of_pages',
    #                                 :stored_sortable,
    #                                 type: :string)] = pages_bucket(100)
    #   end
    # end
    #
    # private
    #
    # def pages
    #   object.member_ids.size
    # end
    #
    # def pages_bucket(size)
    #   n = (pages.to_i / size) * size
    #   "#{n}-#{n + size - 1} pages"
    # end

  end
end
