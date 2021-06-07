# options for select
module Extensions
  module Hyrax
    module SelectTypeListPresenter
      module OptionsForSelect
        def options_for_select
          options = []
          self.each { |r| options << [r.name, r.concern.to_s] }
          options.sort
        end
      end
    end
  end
end
