#  models
AdminSet.class_eval do
  include AllinsonFlex::AdminSetBehavior
end

Hyrax.config.registered_curation_concern_types.each do |klass|
  klass.constantize.prepend Extensions::AllinsonFlex::PrependWorkDynamicSchema
end

#  constructors
AllinsonFlex::AllinsonFlexConstructor.include Extensions::AllinsonFlex::IncludeAllinsonFlexConstructor

#  controllers
Hyrax::Admin::PermissionTemplatesController.prepend Extensions::AllinsonFlex::PrependPermissionTemplatesController
AllinsonFlex::ProfilesController.prepend Extensions::AllinsonFlex::PrependProfilesController

#  forms
Hyrax::Forms::AdminSetForm.prepend Extensions::AllinsonFlex::PrependAdminSetForm
Hyrax::Forms::PermissionTemplateForm.prepend Extensions::AllinsonFlex::PrependPermissionTemplateForm

# importers
AllinsonFlex::Importer.prepend Extensions::AllinsonFlex::PrependImporter
