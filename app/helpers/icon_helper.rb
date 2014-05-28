module IconHelper

  def ion_icon(name, html_class = '')
    "<i class='ion ion-#{name} #{html_class}'></i>".html_safe
  end

  def edit_icon
    fa_icon 'pencil'
  end

  def show_icon
    fa_icon 'eye'
  end

  def delete_icon
    fa_icon 'trash-o'
  end

  def clone_icon
    fa_icon 'copy'
  end

  def start_icon
    fa_icon 'play-circle-o'
  end

  def create_icon
    fa_icon 'plus'
  end

  def schedule_icon
    fa_icon 'clock-o'
  end

  def pause_icon
    fa_icon 'pause'
  end

  def execution_icon
    fa_icon 'play-circle'
  end

  def definition_icon
    fa_icon 'file-text'
  end

  def schedule_icon
    fa_icon 'clock-o'
  end

  def vm_icon
    fa_icon 'desktop'
  end

  def dashboard_icon
    fa_icon 'dashboard'
  end

  def active_icon
    fa_icon 'cog spin'
  end

  def finished_icon
    fa_icon 'flag-checkered'
  end

  def expand_icon
    fa_icon 'plus'
  end

  def download_icon
    fa_icon 'download'
  end

  def search_icon
    fa_icon 'search'
  end

  def abort_icon
    fa_icon 'power-off'
  end

  def restart_icon
    fa_icon 'repeat'
  end
end