# unmodified hyrax methods prepping monkeypatch for ESSI-1361
module Extensions
  module Hyrax
    module Forms
      module CollectionForm
        module AllFilesWithAccess

          private

          def all_files_with_access
            member_presenters(member_work_ids).flat_map(&:file_set_presenters).map { |x| [x.to_s, x.id] }
          end

          def collection_member_service
            @collection_member_service ||= membership_service_class.new(scope: scope, collection: collection, params: blacklight_config.default_solr_params)
          end
        end
      end
    end
  end
end
