module IconHelper

  def ion_icon(name, html_class = '')
    "<i class='ion ion-#{name} #{html_class}'></i>".html_safe
  end

  FA_ICON_MAPPINGS = {
    abort: 'power-off',
    active: 'cog spin',
    clone: 'copy',
    create: 'plus',
    dashboard: 'dashboard',
    definition: 'file-text',
    delete: 'trash-o',
    download: 'download',
    edit: 'pencil',
    execution: 'play-circle',
    expand: 'plus',
    finished: 'flag-checkered',
    pause: 'pause',
    restart: 'repeat',
    schedule: 'clock-o',
    search: 'search',
    show: 'eye',
    start: 'play-circle-o',
    vm: 'desktop',
    config: 'cog',
    provider: 'cogs',
  }
  # Creates a method called *_icon for each icon mapping using font awsome icons
  # Example:
  # def abort_icon
  #   fa_icon 'power-off'
  # end
  FA_ICON_MAPPINGS.each do |key, value|
    define_method("#{key}_icon") do
      fa_icon value
    end
  end
end