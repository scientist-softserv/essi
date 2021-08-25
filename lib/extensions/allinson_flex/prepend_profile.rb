# frozen_string_literal: true
module Extensions
  module AllinsonFlex
    module PrependProfile
      private
        # unmodified from allinson_flex
        def check_admin_set(admin_set_id)
          a = AdminSet.find(admin_set_id)
          return a.members.count > 0
        rescue
          true
        end
    end
  end
end
