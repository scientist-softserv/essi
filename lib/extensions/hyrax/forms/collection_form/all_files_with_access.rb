# modified from hyrax
module Extensions
  module Hyrax
    module Forms
      module CollectionForm
        module AllFilesWithAccess

          private

          # refactored to use helper method, service with increased row limit
          def all_files_with_access
            return [] unless id.present?
            member_file_set_title_ids.sort { |x,y| x[0].upcase <=> y[0].upcase }
          end

          # @return [Array] grandchild FileSet title, id pairs
          def member_file_set_title_ids
            docs = collection_member_service.available_member_fileset_title_ids.response.fetch('docs').select(&:present?)
            docs.flat_map { |e| (e['file_sets_ssim'] || e['file_set_ids_ssim'] || []).zip(e['file_set_ids_ssim'] || []) }.select(&:any?)
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
