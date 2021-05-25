module Extensions
  module Bulkrax
    module ObjectFactory
      module CreateWithDynamicSchema
        # modified to apply a supplied dynamic_schema_id to initial object build
        def create
          attrs = create_attributes
          @object = klass.new(dynamic_schema_id: attrs[:dynamic_schema_id])
          object.reindex_extent = ::Hyrax::Adapters::NestingIndexAdapter::LIMITED_REINDEX
          run_callbacks :save do
            run_callbacks :create do
              klass == ::Collection ? create_collection(attrs) : work_actor.create(environment(attrs))
            end
          end
          log_created(object)
        end
      end
    end
  end
end
