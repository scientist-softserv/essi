# new methods for ESSI-1361, collection thumbnail selection
module Extensions
  module Hyrax
    module Collections
      module CollectionMemberService
        module AvailableMemberFilesetTitleIds

          def available_member_fileset_title_ids
            query_solr_with_and_merge(query_builder: fileset_title_ids_search_builder,
                                      with_params: params,
                                      merge_params: { fl: ['file_sets_ssim', 'file_set_ids_ssim'] })
          end

          private

          # @api private
          #
          def query_solr_with_and_merge(query_builder:, with_params: {}, merge_params: {})
            repository.search(query_builder.with(with_params).merge(merge_params).query)
          end

          # @api private
          #
          # set up a member search builder for returning fileset titles and ids only
          # @return [CollectionMemberSearchBuilder] new or existing
          def fileset_title_ids_search_builder
            @fileset_title_ids_search_builder ||= ::Hyrax::CollectionMemberSearchBuilder.new(scope: scope, collection: collection, search_includes_models: :works)
          end
        end
      end
    end
  end
end
