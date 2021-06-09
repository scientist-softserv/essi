# frozen_string_literal: true

module Bulkrax
  module ImportersHelper
    # borrowd from batch-importer https://github.com/samvera-labs/hyrax-batch_ingest/blob/master/app/controllers/hyrax/batch_ingest/batches_controller.rb
    def available_admin_sets
      # Restrict available_admin_sets to only those current user can desposit to.
      @available_admin_sets ||= Hyrax::Collections::PermissionsService.source_ids_for_deposit(ability: current_ability, source_type: 'admin_set').map do |admin_set_id|
        [AdminSet.find(admin_set_id).title.first, admin_set_id]
      end
    end

    def available_profiles
      @available_profiles ||= AllinsonFlex::Profile.all.order(id: :desc).map { |p| [p.profile_version.to_s, p.id] }
    end
  end
end
