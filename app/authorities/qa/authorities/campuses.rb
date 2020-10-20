module Qa::Authorities
  class Campuses < Base

    def search(id)
      all.select { |place| place[:code].match(id.to_s) }
    end

    def find(id)
      data_for(id) || {}
    end

    def all
      data_for() || []
    end

    private
      DATA = [{ code: 'IUB', label: 'IU Bloomington', url: 'https://www.indiana.edu' },
              { code: 'IUPUI', label: 'IUPUI', url: 'https://www.iupui.edu' },
              { code: 'IUPUC', label: 'IUPUC', url: 'https://www.iupuc.edu' },
              { code: 'IUE', label: 'IU East', url: 'https://www.iue.edu' },
              { code: 'IUFW', label: 'IU Fort Wayne', url: 'https://www.iufw.edu' },
              { code: 'IUK', label: 'IU Kokomo', url: 'https://www.iuk.edu' },
              { code: 'IUN', label: 'IU Northwest', url: 'https://www.iun.edu' },
              { code: 'IUSB', label: 'IU South Bend', url: 'https://www.iusb.edu' },
              { code: 'IUS', label: 'IU Southeast', url: 'https://www.ius.edu' }
             ].map(&:with_indifferent_access).freeze

      def data_for(id = nil)
        return DATA if id.nil?
        DATA.select { |e| e[:code] == id }.first
      end
  end
end
