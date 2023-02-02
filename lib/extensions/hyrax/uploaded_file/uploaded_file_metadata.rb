module Extensions
  module Hyrax
    module UploadedFile
      module UploadedFileMetadata
        def self.prepended(base)
          base.class_eval do
            # values are stashed in memory, only, and lost in some actor/job transitions
            attr_accessor :metadata
          end
        end
      end
    end
  end
end
