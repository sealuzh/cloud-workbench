// For configuration also see: config/initializers/aced_rails.rb
// aced_rails docs: https://github.com/ffloyd/aced_rails
// ace editor docs:
// * HOWTO: http://ace.c9.io/#nav=howto
// * API Reference: https://github.com/ajaxorg/ace/wiki/Embedding-API

var tabSize = 2;
var wrapLimit = null;
var minHeight = 400;
var minWidth  = 350;
// Make sure you import the theme and mode to use in application.js
var ace_theme = 'github';
var ace_mode = 'ruby';

function resize_ace_editor() {
    var ace_div = $('.ace_editor');
    var set_height = function () {
        var height = Math.max(minHeight, $(window).innerHeight() * 0.7);
        ace_div.css({ height: height });
    };
    var set_width = function () {
        ace_div.width('70%');
        var currentWidth = ace_div.width();
        var newWidth = Math.max(minWidth, currentWidth);
        ace_div.width(newWidth);
    };
    set_height();
    set_width();
    $(window).resize(function () {
        set_height();
        set_width();
    });
}

function configure_ace_editor(editor) {
    var session = editor.getSession();
    session.setTabSize(tabSize);
    // Example how to set theme and mode via javascript
    //    editor.setTheme("ace/theme/monokai");
    //    session.setMode("ace/mode/ruby");

    // Soft wrapping
    session.setUseWrapMode(true);
    session.setWrapLimitRange(wrapLimit, wrapLimit);

    // Auto-completion
    require("ace/ext/language_tools");
    editor.setOptions({
        enableBasicAutocompletion: true,
        enableSnippets: true
    });
}

var configure_ace = function() {
    var textarea = $('#benchmark_definition_vagrantfile');
    if (textarea.exists()) {
        // Replace textarea with ace editor
        textarea.acedInitTA({ theme: ace_theme,
                              mode: ace_mode
        });
        resize_ace_editor();
        var editor = textarea.data('ace-div').aced();
        configure_ace_editor(editor);
    }
};

$(document).on('ready page:load', function () {
    configure_ace();
    $('#ace_expand').click(function() {
        resize_ace_editor();
    });
});

