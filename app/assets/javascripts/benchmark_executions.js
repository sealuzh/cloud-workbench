function scrollToBottom (textarea) {
    var maxScrollHeight = textarea[0].scrollHeight;
    textarea.scrollTop(maxScrollHeight)
}

var logRefreshTimeout = null;
function setNextLogRefreshTimeout () {
    var logRefreshTimeoutInMilliseconds = 4000;
    logRefreshTimeout = setTimeout(liveUpdatePrepareLog, logRefreshTimeoutInMilliseconds);
}

function resetNextLogRefreshTimeout() {
    clearTimeout(logRefreshTimeout)
}

function updatePrepareLog(onSuccess) {
    var onSuccess = onSuccess || function() {};
    var benchmark_execution_id = $("#benchmark_execution").attr("data-id");
    var request_url = "/benchmark_executions/" + benchmark_execution_id + "/prepare_log.txt";
    var prepareLogTextarea = $("#prepareLog");
    var success = false;
    $.get( request_url, function(data) {
        prepareLogTextarea.val(data);
        scrollToBottom(prepareLogTextarea);
        onSuccess();
    });
}

function liveUpdatePrepareLog() {
    updatePrepareLog(setNextLogRefreshTimeout);
}

$(document).on('ready page:load', function () {
    // On logging page
    if ($("#prepareLog").exists()) {
        var start = $("#prepareLogRefreshStart");
        var stop  = $("#prepareLogRefreshStop");
        start.click( function() {
            start.toggle();
            stop.toggle();
            liveUpdatePrepareLog();
        });
        stop.click( function() {
            start.toggle();
            stop.toggle();
            resetNextLogRefreshTimeout();
        });
        updatePrepareLog();
    }
});

// Reset timeout when leaving the page via Rails turbolinks.
$(document).on('page:before-change', function() {
    resetNextLogRefreshTimeout();
});
