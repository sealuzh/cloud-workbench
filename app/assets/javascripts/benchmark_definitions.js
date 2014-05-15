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
    //    editor.setTheme("ace/theme/monokai");
    //    session.setMode("ace/mode/ruby");

        // TODO: Language tools are not contained within the aced_rails gem. Consider installing the latest ace version without the gem.
    //    ace.require("ace/ext/language_tools");
    //    ace.require("ace/ext-language_tools");
    //    editor.setOptions({
    //        enableBasicAutocompletion: true,
    //        enableSnippets: true
    //    });
    }
}

$(document).on('ready page:load', function () {
    // TODO: Fix in production environment. Works as expection in Rails development environment.
//    configure_ace_editor()
});
