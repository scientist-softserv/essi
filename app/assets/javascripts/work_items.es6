export default class WorkItems {
  constructor() {
    this.toggle_show_items()
  }

  toggle_show_items(){
    let show = I18n.t('hyrax.works.form.show_child_items')
    let hide = I18n.t('hyrax.works.form.hide_child_items')

    $('body').on('click', '#work-items-button', function(e) {
      const button = $("#work-items-button")
      if (button.text() == show) {
        button.text(hide)
      } else {
        button.text(show)
      }
    })
  }
}
