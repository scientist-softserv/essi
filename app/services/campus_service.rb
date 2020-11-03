module CampusService
  mattr_accessor :authority
  self.authority = Qa::Authorities::Local::FileBasedAuthority.new('campuses')

  def self.select_options
    select_all_options.sort
  end

  def self.select_all_options
    authority.all.map { |element| [element[:label], element[:id]] }
  end

  def self.find(id)
    authority.find(id)
  end

  def self.campuses
    authority.all.map { |element| Campus.new(authority.find(element[:id])) }
  end

  class Campus
    attr_accessor :term, :id, :img_src, :img_alt

    def initialize(values)
      @term = values[:term]
      @id = values[:id]
      @img_src = values[:img_src]
      @img_alt = values[:img_alt]
    end
  end
end
