# active fedora node cache initialization
ActiveFedora::Orders::OrderedList.prepend Extensions::ActiveFedora::Orders::OrderedList::InitializeNodeCache

# extracted text support
Hyrax::DownloadsController.prepend Extensions::Hyrax::DownloadsController::ExtractedText
Hyrax::FileSetPresenter.include Extensions::Hyrax::FileSetPresenter::ExtractedText

# viewing hint support
IIIFManifest::ManifestBuilder::ImageBuilder.include Extensions::IIIFManifest::ManifestBuilder::ImageBuilder::ViewingHint
Hyrax::Forms::FileManagerForm.include Extensions::Hyrax::Forms::FileManagerForm::ViewingMetadata
Hyrax::FileSetPresenter.include Extensions::Hyrax::FileSetPresenter::ViewingHint

# TODO: determine if needed?
# iiif manifest support
Hyrax::WorkShowPresenter.prepend Extensions::Hyrax::WorkShowPresenter::ManifestMetadata

# add campus logo information when available.
Hyrax::CollectionPresenter.prepend Extensions::Hyrax::CollectionPresenter::CampusLogo
Hyrax::WorkShowPresenter.prepend Extensions::Hyrax::WorkShowPresenter::CampusLogo
Hyrax::FileSetPresenter.prepend Extensions::Hyrax::FileSetPresenter::CampusLogo

# add collection banner to works and file sets.
Hyrax::FileSetPresenter.include Extensions::Hyrax::FileSetPresenter::CollectionBanner
Hyrax::WorkShowPresenter.include Extensions::Hyrax::WorkShowPresenter::CollectionBanner

# primary fields support
Hyrax::Forms::WorkForm.include Extensions::Hyrax::Forms::WorkForm::PrimaryFields
# support for worktype-specific #work_requires_files?
Hyrax::Forms::WorkForm.include Extensions::Hyrax::Forms::WorkForm::WorkRequiresFiles

# IIIF Thumbnails for both types of Collections
Hyrax::AdminSetIndexer.include ESSI::IIIFCollectionThumbnailBehavior
Hyrax::CollectionIndexer.include ESSI::IIIFCollectionThumbnailBehavior

# Use FileSet to store and display collection banner/logo image
Hyrax::Forms::CollectionForm.prepend Extensions::Hyrax::Forms::CollectionForm::FileSetBackedBranding
Hyrax::CollectionPresenter.prepend Extensions::Hyrax::CollectionPresenter::FileSetBackedBranding
Hyrax::Dashboard::CollectionsController.prepend Extensions::Hyrax::Dashboard::CollectionsController::FileSetBackedBranding

# purl controller support
Hyrax::FileSetPresenter.include Extensions::Hyrax::FileSetPresenter::SourceMetadataIdentifier

# bulkrax overrides
Bulkrax::ObjectFactory.prepend Extensions::Bulkrax::ObjectFactory::Structure
Bulkrax::Entry.prepend Extensions::Bulkrax::Entry::AllinsonFlexFields
Bulkrax::Entry.prepend Extensions::Bulkrax::Entry::SingularizeRightsStatement
Bulkrax::Exporter.prepend Extensions::Bulkrax::Exporter::LastRun
Bulkrax::Importer.prepend Extensions::Bulkrax::Importer::LastRun

# actor customizations
Hyrax::CurationConcern.actor_factory.insert Hyrax::Actors::TransactionalRequest, ESSI::Actors::PerformLaterActor
Hyrax::CurationConcern.actor_factory.swap Hyrax::Actors::CreateWithRemoteFilesActor, ESSI::Actors::CreateWithRemoteFilesOrderedMembersStructureActor
Hyrax::CurationConcern.actor_factory.swap Hyrax::Actors::CreateWithFilesActor, Hyrax::Actors::CreateWithFilesOrderedMembersActor

Hyrax::Actors::BaseActor.prepend Extensions::Hyrax::Actors::BaseActor::UndoAttributeArrayWrap

# .jp2 conversion settings
Hydra::Derivatives.kdu_compress_path = ESSI.config.dig(:essi, :kdu_compress_path)
Hydra::Derivatives.kdu_compress_recipes =
  Hydra::Derivatives.kdu_compress_recipes.with_indifferent_access
                    .merge(ESSI.config.dig(:essi, :jp2_recipes) || {})

# ocr derivation
Hyrax::DerivativeService.services.unshift ESSI::FileSetOCRDerivativesService

# add customized terms, currently just campus, to collection forms
Hyrax::Forms::CollectionForm.include Extensions::Hyrax::Forms::CollectionForm::CustomizedTerms
Hyrax::CollectionPresenter.include Extensions::Hyrax::CollectionPresenter::CustomizedTerms
AdminSet.include Extensions::Hyrax::AdminSet::CampusOnAdminSet
Hyrax::Forms::AdminSetForm.include Extensions::Hyrax::Forms::AdminSetForm::CustomizedTerms

VisibilityCopyJob.prepend Extensions::Hyrax::Jobs::ShortCircuitOnNil
InheritPermissionsJob.prepend Extensions::Hyrax::Jobs::ShortCircuitOnNil

# Hyrax user lookup
Hyrax::UsersController.prepend Extensions::Hyrax::UsersController::FindUser

# Hyrax Work Type selection
Hyrax::SelectTypeListPresenter.prepend Extensions::Hyrax::SelectTypeListPresenter::OptionsForSelect
