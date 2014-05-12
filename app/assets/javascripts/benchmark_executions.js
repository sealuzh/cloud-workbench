function scrollToBottom (textarea) {
    var maxScrollHeight = textarea[0].scrollHeight;
    textarea.scrollTop(maxScrollHeight)
}

var logRefreshTimeouts = [];
function setNextLogRefreshTimeout (logTextarea, action) {
    var logRefreshTimeoutInMilliseconds = 4000;
    var nextTimeout = setTimeout(function() {
                                    liveUpdateLog(logTextarea, action);
                                 }, logRefreshTimeoutInMilliseconds);
    logRefreshTimeouts.push(nextTimeout);
}

function resetAllLogRefreshTimeouts() {
    for (var i = 0; i < logRefreshTimeouts.length; i++) {
        clearTimeout(logRefreshTimeouts[i]);
    }
    logRefreshTimeouts = [];
}

function updateLog(logTextarea, action, onSuccess) {
    var onSuccess = onSuccess || function() {};
    var benchmark_execution_id = $("#benchmark_execution").attr("data-id");
    var request_url = "/benchmark_executions/" + benchmark_execution_id + "/" + action + ".txt";
    $.get( request_url, function(data) {
        logTextarea.val(data);
        scrollToBottom(logTextarea);
        onSuccess();
    });
}

function liveUpdateLog(logTextarea, action) {
    var setNextTimeoutOnSuccess = function() {
        setNextLogRefreshTimeout(logTextarea, action);
    };
    updateLog(logTextarea, action, setNextTimeoutOnSuccess);
}

function initLiveLog(id, action) {
    var logTextarea = $("#" + id);
    if (logTextarea.exists()) {
        var start = $("#" + id + "RefreshStart");
        var stop  = $("#" + id + "RefreshStop");
        start.click( function() {
            start.toggle();
            stop.toggle();
            liveUpdateLog(logTextarea, action);
        });
        stop.click( function() {
            start.toggle();
            stop.toggle();
            resetAllLogRefreshTimeouts();
        });
        updateLog(logTextarea, action);
    }
}

$(document).on('ready page:load', function () {
    initLiveLog('prepareLog', 'prepare_log');
    initLiveLog('releaseResourcesLog', 'release_resources_log');
});

// Reset timeout when leaving the page via Rails turbolinks.
$(document).on('page:before-change', function() {
    resetAllLogRefreshTimeouts();
});
