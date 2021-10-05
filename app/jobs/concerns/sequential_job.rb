module SequentialJob
  # extend ActiveSupport::Concern

  def self.prepended(mod)
    mod.singleton_class.prepend(ClassMethods)

    mod.class_eval do
      before_perform do |job|
        if Thread.current[:essi_nested_job_parent_id].nil?
          Thread.current[:essi_nested_job_parent_id] = job.job_id
          Rails.logger.debug { "Nested job queue not empty with no parent_id set!" unless Thread.current[:essi_nested_job_queue].blank? }
          Thread.current[:essi_nested_job_queue] = []
        end
      end

      after_perform do |job|
        # actually enqueue jobs
        while nested_job = Thread.current[:essi_nested_job_queue].shift do
          Rails.logger.debug { "Enqueuing #{nested_job.inspect}. #{Thread.current[:essi_nested_job_queue].size} jobs left to queue." }
          nested_job.enqueue
        end
        Thread.current[:essi_nested_job_parent_id] = nil
      end
    end
  end

  module ClassMethods
    def perform_later(*args)
      if Thread.current[:essi_nested_job_parent_id].nil?
        Rails.logger.debug { "Thread var parent_id is nil. Calling super.perform_later with args #{args.inspect}" }
        super(*args)
      else
        # nested_job_service.push(new(*args))
        Rails.logger.debug { "Thread storing #{self.name} with args #{args.inspect} with #{Thread.current[:essi_nested_job_queue].size} jobs in the queue." }
        Thread.current[:essi_nested_job_queue].push(new(*args))
      end
    end
  end
end