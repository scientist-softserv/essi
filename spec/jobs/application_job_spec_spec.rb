require 'rails_helper'

class ApplicationTestJob < ApplicationJob
  cattr_accessor :class_job_log, :jobs_done
  
  def perform(job_count)
    id = job_count
    
    r = [0, 0.02, 0.05, 0.01, 0.1, 0.03][job_count]
    sleep(r)
    if job_count < 5
      ApplicationTestJob.perform_later(job_count + 1)
    else
      self.jobs_done = true
    end
    sleep(r)
    self.class_job_log.send { |a| a.push id }
    self.class_job_log.await
  end
end

describe 'ApplicationJobSpec' do
  before do
    ApplicationTestJob.class_job_log = Concurrent::Agent.new([])
    ApplicationTestJob.jobs_done = false
    ActiveJob::Base.enable_test_adapter ActiveJob::QueueAdapters::AsyncAdapter.new max_threads: 2 * Concurrent.processor_count
  end
  
  after do
    ActiveJob::Base.enable_test_adapter ActiveJob::QueueAdapters::TestAdapter.new
  end
  
  context 'Job based on ApplicationJob' do
    it 'run jobs in order by waiting to enqueue' do
      expect(ApplicationTestJob.queue_adapter).to be_a ActiveJob::QueueAdapters::AsyncAdapter
      ApplicationTestJob.perform_later(1)
      while !ApplicationTestJob.jobs_done do
        sleep 1
      end
      expect(ApplicationTestJob.class_job_log.value).to eq [1, 2, 3, 4, 5]
    end
  end
end
