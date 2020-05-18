module ESSI
  module IIIFCollectionThumbnailBehavior
    extend ActiveSupport::Concern

    included do
      self.thumbnail_path_service = IIIFCollectionThumbnailPathService
    end
  end
end
