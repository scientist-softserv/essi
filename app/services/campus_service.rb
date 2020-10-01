module CampusService
  mattr_accessor :authority
  self.authority = Qa::Authorities::Campuses.new

  def self.select_options
    authority.all.map { |element| [element[:label], element[:code]] }.sort
  end

  def self.select_all_options
    authority.all.map do |element|
      [element[:label], element[:code]]
    end
  end

  def self.find(id)
    authority.find(id)
  end
end
