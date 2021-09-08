# written as an Entry module, but needs to be applied to a specific subclass (e.i. CsvEntry)
module Extensions
  module Bulkrax
    module Entry
      module DynamicSchemaField
        def build_metadata
          super
          add_dynamic_schema
          self.parsed_metadata
        end

        def add_dynamic_schema
          return if self.parsed_metadata['dynamic_schema_id'].present?
          context_id = find_metadata_context_for(admin_set_id: self.parsed_metadata['admin_set_id'],
                                                 profile_id: profile_id)
          self.parsed_metadata['dynamic_schema_id'] ||= ::AllinsonFlex::DynamicSchema.find_by(context_id: context_id, allinson_flex_class: factory_class.to_s)&.id
        end

        def profile_id
          profile_version = self.parsed_metadata['profile_version']
          if profile_version.to_i.positive?
            ::AllinsonFlex::Profile.where(profile_version: profile_version.to_f).first&.id
          else
            [self.parsed_metadata['profile_id'], parser.parser_fields&.[]('profile_id')].map(&:to_i).select(&:positive?).first
          end
        end

        def find_metadata_context_for(admin_set_id:, profile_id:)
          ::AllinsonFlex::Context.order("created_at asc").where(profile_id: profile_id).where.not(admin_set_ids: [nil, []]).select { |c| c.admin_set_ids.include?(admin_set_id) }.last ||
            ::AllinsonFlex::Context.where(name: 'default').order('created_at').last
        end
      end
    end
  end
end
