module HoldingLocationService
  mattr_accessor :authority
  self.authority = Qa::Authorities::IucatLibraries.new
  #self.authority = Qa::Authorities::Local::FileBasedAuthority.new('holding_locations')

  def self.select_options
    select_all_options.sort
  end

  def self.select_all_options
    authority.all.map { |element| [element[:label], element[:code]] }
  end

  def self.find(id)
    authority.find(id)
  end
end
