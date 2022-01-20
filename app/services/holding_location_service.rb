module HoldingLocationService
  mattr_accessor :authority
  self.authority = Qa::Authorities::IucatLibraries.new

  def self.select_options
    select_all_options.sort
  end

  def self.select_all_options
    results = Rails.cache.fetch('HoldLoc-v1-_ALL_', expires_in: 1.hour, race_condition_ttl: 1.hour) do
      authority.all
    end
    results.map { |element| [element[:label], element[:code]] }
  end

  def self.find(id)
    Rails.cache.fetch("HoldLoc-v1-#{id}", expires_in: 1.hour, race_condition_ttl: 1.hour) do
      authority.find(id)
    end
  end
end
