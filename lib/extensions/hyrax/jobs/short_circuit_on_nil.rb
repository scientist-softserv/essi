module Extensions::Hyrax::Jobs::ShortCircuitOnNil
  def perform(arg)
    Rails.logger.debug "#{self.class} called with nil argument. Skipping perform." if arg.nil?
    super(arg) unless arg.nil?
  end
end
