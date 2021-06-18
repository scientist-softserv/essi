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

          # modified from hyrax to support custom solr params, specifically more rows
          # @param solr_params [Hash] the solr parameters to merge into defaults
          # @return [Hyrax::Collections::CollectionMemberService]
          def collection_member_service(solr_params: { rows: 10_000 })
            @collection_member_service ||= membership_service_class.new(scope: scope, collection: collection, params: blacklight_config.default_solr_params.deep_dup.merge(solr_params))
          end
        end
      end
    end
  end
end
