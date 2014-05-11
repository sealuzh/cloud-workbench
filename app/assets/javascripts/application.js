// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks

// Metis Admin Theme and dependencies
//= require modernizr/modernizr.min
//= require jquery-validation/jquery.validate
//= require validVal/jquery.validVal
//= require validationEngine/jquery.validationEngine
//= require metis_admin/metis_admin

//= require_tree .

$.fn.exists = function () {
    return this.length !== 0;
}

// The on page:load hook is required in order to support Rails turbolinks.
// For more information see: https://github.com/rails/turbolinks#events
// RailsCast with example and background: http://railscasts.com/episodes/390-turbolinks
$(document).on('ready page:load', function () {
    // Tooltips
    $(function () { $('.tooltip-show').tooltip('show');});
    $(function () { $('.tooltip-hide').tooltip('hide');});
    $(function () { $('.tooltip-destroy').tooltip('destroy');});
    $(function () { $('.tooltip-toggle').tooltip('toggle');});
    $(function () { $(".tooltip-options a").tooltip({html : true });});
});
