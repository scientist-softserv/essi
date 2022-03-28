module ESSI
  class CollectionIndexer < ::Hyrax::CollectionWithBasicMetadataIndexer
    include ESSI::IndexesCollectionDescendants
  end
end
