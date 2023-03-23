// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//=
//= require turbolinks
//
// Required by Blacklight
//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/selectable
//= require jquery-ui/widgets/sortable
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require i18n
//= require i18n/translations

//= require blacklight/blacklight
//= require blacklight_gallery
//= require cable
//= require nestedSortable/jquery.mjs.nestedSortable
//= require openseadragon
//= require hyrax
//= require iiif_print

//= require bulkrax/application
//= require allinson_flex/application
//= require_tree .

Blacklight.onLoad(function() {
  Initializer = require('essi_boot')
  window.essi = new Initializer()
})
