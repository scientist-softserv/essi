# Resolve deprecation warning re: raw query for ids
# @todo remove after upgrade to Hyrax 3.x
module Extensions
  module Hyrax
    module Collections
      module PermissionsService
        module SourceIds
          def self.included(base)
            base.class_eval do
              # @api private
              #
              # IDs of collections/or admin_sets a user can access based on participant roles.
              #
              # @param access [Array<String>] one or more types of access (e.g. Hyrax::PermissionTemplateAccess::MANAGE, Hyrax::PermissionTemplateAccess::DEPOSIT, Hyrax::PermissionTemplateAccess::VIEW)
              # @param ability [Ability] the ability coming from cancan ability check
              # @param source_type [String] 'collection', 'admin_set', or nil to get all types
              # @param exclude_groups [Array<String>] name of groups to exclude from the results
              # @return [Array<String>] IDs of collections and admin sets for which the user has specified roles
              def self.source_ids_for_user(access:, ability:, source_type: nil, exclude_groups: [])
                scope = ::Hyrax::PermissionTemplateAccess.for_user(ability: ability, access: access, exclude_groups: exclude_groups)
                                                .joins(:permission_template)
                ids = scope.select(:source_id).distinct.pluck(:source_id)
                return ids unless source_type
                filter_source(source_type: source_type, ids: ids)
              end
              private_class_method :source_ids_for_user
            end
          end
        end
      end
    end
  end
end
