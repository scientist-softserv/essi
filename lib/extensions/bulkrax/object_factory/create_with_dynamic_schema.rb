module Extensions
  module Bulkrax
    module ObjectFactory
      module CreateWithDynamicSchema
        # unmodified
        def create
          attrs = create_attributes
          @object = klass.new
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
