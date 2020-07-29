module Processors
  class OCR < Hydra::Derivatives::Processors::Processor
    include Hydra::Derivatives::Processors::ShellBasedProcessor

    def self.encode(path, options, output_file)
      file_name = File.basename(path)
      existing_file = pre_ocr_file(file_name)
      if existing_file
        Rails.logger.info "Copying Pre-derived OCR file #{existing_file} to #{output_file}."
        execute "cp #{existing_file} #{output_file}"
      else
        clean_file = ocr_clean_file(path)
        bitonal_file = ocr_bitonal_file(clean_file)
        remove_tmp_file(clean_file)
        execute "tesseract #{bitonal_file} #{output_file.gsub('.xml', '')} #{options[:options]} alto"
        remove_tmp_file(bitonal_file)
      end
    end

    def options_for(_format)
      {
        options: string_options
      }
    end

    def self.pre_ocr_file(filename)
      Rails.logger.info 'Checking for a Pre-derived OCR folder.'
      return false unless ESSI.config.dig(:essi, :derivatives_folder)

      Rails.logger.info 'Checking for a Pre-derived OCR file.'
      ocr_filename = "#{File.basename(filename, '.*')}-alto.xml"
      ocr_file = File.join(ESSI.config.dig(:essi, :derivatives_folder), ocr_filename)
      return false unless File.exist?(ocr_file)

      ocr_file
    end

    def self.ocr_clean_file(path)
      clean_file = File.join(Hydra::Derivatives.temp_file_base, "clean_#{File.basename(path)}")
      execute "#{Rails.root.join('bin', 'textcleaner')} #{path} #{clean_file}"
      clean_file
    end

    def self.ocr_bitonal_file(path)
      bitonal_file = File.join(Hydra::Derivatives.temp_file_base, "bitonal_#{File.basename(path)}")
      execute "convert #{path} -threshold 42% #{bitonal_file}"
      bitonal_file
    end

    def self.remove_tmp_file(file)
      execute "rm #{file}"
    end

    private

    def string_options
      "-l #{language}"
    end

    def language
      directives.fetch(:language, :eng)
    end
  end
end
