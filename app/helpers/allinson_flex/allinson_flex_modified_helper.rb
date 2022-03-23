# frozen_string_literal: true

# override (from Hyrax 2.5.0) - new module
module AllinsonFlex::AllinsonFlexModifiedHelper
  # borrowed from batch-importer https://github.com/samvera-labs/hyrax-batch_ingest/blob/master/app/controllers/hyrax/batch_ingest/batches_controller.rb
  def accessible_admin_sets
    # Restrict accessible_admin_sets to only those current user can desposit to.
    @accessible_admin_sets ||= Hyrax::Collections::PermissionsService.source_ids_for_deposit(ability: current_ability, source_type: 'admin_set')
    @accessible_admin_sets ||= []
  end

  # an AdminSet is only usable if it has an active_workflow
  def accessible_admin_sets_with_active_workflow
    accessible_admin_sets.select { |admin_set_id| Hyrax::PermissionTemplate.find_by(source_id: admin_set_id)&.active_workflow.present? }
  end

  def usable_admin_sets
    @usable_admin_sets ||= format_admin_set_ids(accessible_admin_sets_with_active_workflow)
  end

  def unusable_admin_sets
    @unusable_admin_sets ||= format_admin_set_ids(accessible_admin_sets - accessible_admin_sets_with_active_workflow)
  end

  private
    def format_admin_set_ids(admin_set_ids)
      AdminSet.search_with_conditions(id: admin_set_ids).map do |solr_hit|
        [solr_hit['title_tesim'].first, solr_hit.id]
      end
    end
end

