#  models
AdminSet.class_eval do
  include AllinsonFlex::AdminSetBehavior
end

#  controllers
Hyrax::Admin::PermissionTemplatesController.prepend Extensions::AllinsonFlex::PrependPermissionTemplatesController
AllinsonFlex::ProfilesController.prepend Extensions::AllinsonFlex::PrependProfilesController

#  forms
Hyrax::Forms::AdminSetForm.prepend Extensions::AllinsonFlex::PrependAdminSetForm
Hyrax::Forms::PermissionTemplateForm.prepend Extensions::AllinsonFlex::PrependPermissionTemplateForm
