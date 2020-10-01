# Makes Show page display terms customizable
module Extensions
  module Hyrax
    module CollectionPresenter
      module CustomizedTerms
        def self.included(base)
          base.class_eval do
            # Terms is the list of fields displayed by
            # app/views/collections/_show_descriptions.html.erb
            def self.terms
              [:total_items, :size, :modified_date, :resource_type, :creator, :contributor,
               :keyword, :license, :publisher, :date_created, :subject, :language,
               :identifier, :based_near, :campus, :related_url]
            end

            delegate :campus, to: :solr_document
          end
        end
      end
    end
  end
end
