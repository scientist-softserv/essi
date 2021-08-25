# frozen_string_literal: true
module Extensions
  module AllinsonFlex
    module PrependProfile
      private
        # modified from allinson_flex: checks profile_version match
        def check_admin_set(admin_set_id)
          a = AdminSet.find(admin_set_id)
          return a.members.select { |m| m.profile_version == profile_version }.count > 0
        rescue
          true
        end
    end
  end
end
