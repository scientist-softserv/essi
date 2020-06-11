module ESSI
  module ApplyOCR
    def create(env)
      apply_creation_data_to_curation_concern(env)
      apply_save_data_to_curation_concern(env)
      apply_ocr_option_data_to_curation_concern(env)
      save(env) && next_actor.create(env) && run_callbacks(:after_create_concern, env)
    end

    private

      def apply_ocr_option_data_to_curation_concern(env)
        return unless ESSI.config.dig(:essi, :index_ocr_files)
        env.curation_concern.ocr_state = "searchable"
      end
  end
end
