module SequentialJob
  def self.prepended(mod)
    mod.singleton_class.prepend(ClassMethods)

    mod.class_eval do
      around_perform do |job, block|
        if Thread.current[:seq_job_parent_id].nil?  # Lowest perform call in stack, store job id.
          Thread.current[:seq_job_parent_id] = job.job_id
          Rails.logger.debug { "SequentialJob: Queue not empty with no parent_id set!" unless Thread.current[:seq_job_queue].blank? }
          Thread.current[:seq_job_queue] = []
        end

        block.call

        # Check that this job id matches parent job id in thread memory
        if job.job_id == Thread.current[:seq_job_parent_id]
          # actually enqueue jobs
          while nested_job = Thread.current[:seq_job_queue].shift do
            Rails.logger.debug { "SequentialJob: Enqueuing #{nested_job.class.name}. #{Thread.current[:seq_job_queue].size} jobs left to queue." }
            nested_job.enqueue
          end
          Thread.current[:seq_job_parent_id] = nil  # Clear stored parent id
        end
      end
    end
  end

  module ClassMethods
    def perform_later(*args)
      if Thread.current[:seq_job_parent_id].nil?  # Lowest perform_later call in stack, act normal.
        super(*args)
      else  # Nested perform call, store job for later.
        Rails.logger.debug { "SequentialJob: Thread storing #{self.name} with #{Thread.current[:seq_job_queue].size} jobs in the queue." }
        Thread.current[:seq_job_queue].push(new(*args))
      end
    end
  end
end