# Job classes based on ApplicationJob will wait to enqueue any nested jobs until
# the current job has finished.
class ApplicationJob < ActiveJob::Base
  before_perform do |job|
    if Thread.current[:essi_nested_job_parent_id].nil?
      Thread.current[:essi_nested_job_parent_id] = job.job_id
      Rails.logger.debug { "Nested job queue not empty with no parent_id set!" unless Thread.current[:essi_nested_job_queue].blank? }
      Thread.current[:essi_nested_job_queue] = []
    end
  end
  
  after_perform do |job|
    Thread.current[:essi_nested_job_parent_id] = nil # Does this fail when perform_now is used?
    # actually enqueue jobs
    while nested_job = Thread.current[:essi_nested_job_queue].shift do
      Rails.logger.debug { "Enqueuing #{nested_job.inspect}. #{Thread.current[:essi_nested_job_queue].size} jobs left to queue." }
      nested_job.enqueue
    end
  end
  
  # store jobs to be enqueued after current job is complete
  def self.perform_later(*args)
    if Thread.current[:essi_nested_job_parent_id].nil?
      Rails.logger.debug { "Thread var parent_id is nil. Calling super.perform_later with args #{args.inspect}" }
      super(*args)
    else
      # nested_job_service.push(new(*args))
      Rails.logger.debug { "Thread storing #{self.class} with args #{args.inspect} with #{Thread.current[:essi_nested_job_queue].size} jobs in the queue." }
      Thread.current[:essi_nested_job_queue].push(new(*args))
    end
  end
  
end
