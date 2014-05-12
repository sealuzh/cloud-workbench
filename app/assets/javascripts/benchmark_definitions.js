// For configuration also see: config/initializers/aced_rails.rb
// aced_rails docs: https://github.com/ffloyd/aced_rails
// ace editor docs:
// * HOWTO: http://ace.c9.io/#nav=howto
// * API Reference: https://github.com/ajaxorg/ace/wiki/Embedding-API

var configure_ace_editor = function() {
    var textarea = $('#benchmark_definition_vagrantfile');
    if (textarea.exists()) {
        textarea.acedInitTA({ theme: 'github',
                              mode: 'ruby'
        });
        var editor = textarea.data('ace-div').aced();
        var session = editor.getSession();
        session.setTabSize(2);

        // Example how to set theme and mode via javascript
    //    editor.setTheme("ace/theme/monokai");
    //    session.setMode("ace/mode/ruby");

        // Auto-completion
        require("ace/ext/language_tools");
        editor.setOptions({
            enableBasicAutocompletion: true,
            enableSnippets: true
        });
    }
};

$(document).on('ready page:load', function () {
    configure_ace_editor();
});
