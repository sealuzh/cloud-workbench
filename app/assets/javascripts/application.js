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

//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require bootstrap/bootstrap

// jquery plugins
//= require jquery.jscrollpane
//= require jquery.mousewheel

// Replace default browser confirm dialog with bootstrap modal: https://github.com/ifad/data-confirm-modal
//= require data-confirm-modal
//= require data-confirm-modal-config

// Ace editor extensions
// =require ace/ace
//= require ace/worker-javascript
//= require ace/mode-ruby
//= require ace/theme-github
//= require ace/snippets/ruby
//= require ace/ext-language_tools
//= require aced-rails/aced-rails.js.coffee

// AdminLTE bootstrap theme and dependencies
//= require admin-lte/app

// Custom javascript
// Note that the family of require directives prevents files from being included twice in the output.
// from http://edgeguides.rubyonrails.org/asset_pipeline.html#manifest-files-and-directives
//= require utilities
//= require scrollbar
//= require_tree .



// Require as last resource according to jquery turbolinks docs: https://github.com/kossnocorp/jquery.turbolinks
//= require turbolinks