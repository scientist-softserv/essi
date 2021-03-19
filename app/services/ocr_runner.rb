class OCRRunner < Hydra::Derivatives::Runner

  # Facilitate storing the output as :extracted_text
  def self.output_file_service
    @output_file_service || ::PersistDirectlyContainedOutputFileService
  end

  def self.processor_class
    ::Processors::OCR
  end
end
