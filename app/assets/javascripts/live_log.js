function scrollToBottom (textarea) {
    var maxScrollHeight = textarea[0].scrollHeight;
    textarea.scrollTop(maxScrollHeight)
}

var logRefreshTimeouts = {};
function setNextLogRefreshTimeout (logTextarea, action) {
    var logRefreshTimeoutInMilliseconds = 4000;
    var nextTimeout = setTimeout(function() {
                                    liveRefreshLog(logTextarea, action);
                                 }, logRefreshTimeoutInMilliseconds);
    logRefreshTimeouts[action] = nextTimeout;
}

function resetLogRefreshTimeout(action) {
    clearTimeout(logRefreshTimeouts[action]);
}

function resetAllLogRefreshTimeouts() {
    Object.keys(logRefreshTimeouts).forEach( function(key) {
        resetLogRefreshTimeout(key);
    });
}

function refreshLog(logTextarea, action, onSuccess) {
    var onSuccess = onSuccess || function() {};
    var benchmark_execution_id = $("#benchmark_execution").attr("data-id");
    var request_url = "/benchmark_executions/" + benchmark_execution_id + "/" + action + ".txt";
    logTextarea.load(request_url, function() {
        initScrollbar();
        scrollToBottom(logTextarea);
        onSuccess();
    });
}

function liveRefreshLog(logTextarea, action) {
    var setNextTimeoutOnSuccess = function() {
        setNextLogRefreshTimeout(logTextarea, action);
    };
    refreshLog(logTextarea, action, setNextTimeoutOnSuccess);
}

function initLiveRefresh(id, action) {
    var logTextarea = $("#" + id);
    if (logTextarea.exists()) {
        var start = $("#" + id + "RefreshStart");
        var stop  = $("#" + id + "RefreshStop");
        start.click( function() {
            start.toggle();
            stop.toggle();
            liveRefreshLog(logTextarea, action);
        });
        stop.click( function() {
            start.toggle();
            stop.toggle();
            resetLogRefreshTimeout(action);
        });
        refreshLog(logTextarea, action);
    }
}

function resetLiveRefreshButton(id) {
    var start = $("#" + id + "RefreshStart");
    var stop  = $("#" + id + "RefreshStop");
    start.show();
    stop.hide();
}

$(document).on('ready page:load', function () {
    initLiveRefresh('prepareLog', 'prepare_log');
    initLiveRefresh('releaseResourcesLog', 'release_resources_log');
});

// Reset timeout when leaving the page via Rails turbolinks.
$(document).on('page:before-change', function() {
    resetLiveRefreshButton('prepareLog');
    resetLiveRefreshButton('releaseResourcesLog');
    resetAllLogRefreshTimeouts();
});
