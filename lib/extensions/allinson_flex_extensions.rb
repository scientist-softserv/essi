#  models
AdminSet.class_eval do
  include AllinsonFlex::AdminSetBehavior
end

Hyrax.config.registered_curation_concern_types.each do |klass|
  klass.constantize.prepend Extensions::AllinsonFlex::PrependWorkDynamicSchema
end

#  controllers
Hyrax::Admin::PermissionTemplatesController.prepend Extensions::AllinsonFlex::PrependPermissionTemplatesController

#  forms
Hyrax::Forms::AdminSetForm.prepend Extensions::AllinsonFlex::PrependAdminSetForm
Hyrax::Forms::PermissionTemplateForm.prepend Extensions::AllinsonFlex::PrependPermissionTemplateForm
