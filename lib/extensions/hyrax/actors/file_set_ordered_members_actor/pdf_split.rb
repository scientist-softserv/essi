module Extensions
  module Hyrax
    module Actors
      module FileSetOrderedMembersActor
        # Essi's file_set_actor_class is the FileSetOrderedMembersActor which
        # has its own #attach_to_work.  Mixing in IiifPrint's #attach_to_work
        # so PDF's can be split
        # @see Extensions::AttachFilesToWorkWithOrderedMembersJob::ImportMetadata#add_uploaded_files
        module PdfSplit
          include IiifPrint::Actors::FileSetActorDecorator
        end
      end
    end
  end
end
