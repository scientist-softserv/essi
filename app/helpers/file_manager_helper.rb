module FileManagerHelper
  def ocr_check(presenter)
    return '✅' if presenter.extracted_text?
    '❌'
  end
end
