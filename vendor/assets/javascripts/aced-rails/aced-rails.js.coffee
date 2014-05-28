# Source from: https://github.com/ffloyd/aced_rails

# Reference jQuery
$ = jQuery

$.fn.extend
  acedInit: (options) ->
    options = {} unless options?

    return @each ->
      editor = ace.edit(this)
      if options.theme?
        editor.setTheme "ace/theme/#{options.theme}"
      if options.mode?
        editor.getSession().setMode "ace/mode/#{options.mode}"
      $(this).data 'ace-editor', editor

  acedInitTA: (options) ->
    return @each ->
      ta      = $(this)
      height  = ta.height()
      width   = ta.width()

      div = $("<div style=\"height: #{height}px; width: #{width}px;\"></div>")
      ta.hide()
      ta.before div
      ta.data 'ace-div', div

      div.acedInit options

      editor = div.aced()
      editor.setValue ta.text()
      editor.clearSelection()
      editor.getSession().on 'change', (e) ->
        ta.text editor.getValue()

  aced: ->
    $(this).data 'ace-editor'

  acedSession: ->
    $(this).data('ace-editor').getSession()

$(document).ready ->
  $('div[ace-editor]').each ->
    div = $(this)
    theme = div.attr 'ace-theme'
    mode  = div.attr 'ace-mode'

    div.acedInit
      theme: theme
      mode:  mode

  $('textarea[ace-editor]').each ->
    ta = $(this)
    theme = ta.attr 'ace-theme'
    mode  = ta.attr 'ace-mode'

    ta.acedInitTA
      theme: theme
      mode:  mode