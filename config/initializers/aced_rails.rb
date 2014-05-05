AcedRails.configure do |config|
  # select themes
  # available themes:
  #   ambiance, chaos, chrome, clouds, clouds_midnight, cobalt, crimson_editor,
  #   dawn, dreamweaver, eclipse, github, idle_fingers, kr, merbivore, merbivore_soft,
  #   mono_industrial, monokai, pastel_on_dark, solarized_dark, solarized_light, textmate,
  #   tomorrow, tomorrow_night, tomorrow_night_blue, tomorrow_night_bright,
  #   tomorrow_night_eighties, twilight, vibrant_ink, xcode
  config.themes = [:github]

  # select modes
  # available modes:
  #   abap, asciidoc, c9search, c_cpp, clojure, coffee, coldfusion,
  #   csharp, css, curly, dart, diff, django, dot, glsl, golang, groovy,
  #   haml, haxe, html, jade, java, javascript, json, jsp, jsx, latex, less,
  #   liquid, lisp, livescript, lua, luapage, lucene, makefile, markdown,
  #   objectivec, ocaml, perl, pgsql, php, powershell, python, r, rdoc, rhtml,
  #   ruby, scad, scala, scheme, scss, sh, sql, stylus, svg, tcl, tex, text,
  #   textile, tm_snippet, typescript, vbscript, xml, xquery, yaml
  config.modes = [:ruby]

  # select workers:
  # available workers (use in pair with themes):
  #   coffee, css, javascript, json, php, xquery
  config.workers = [:javascript]

  # select keybindings
  # available keybindings:
  #   emacs, vim
  config.keybindings = []

  # select extensions:
  # available extensions:
  #   searchbox, spellcheck, static_highlight, textarea
  config.exts = []
end