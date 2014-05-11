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
