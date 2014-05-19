module IconHelper

  def ion_icon(name)
    "<i class='ion ion-#{name}'></i>".html_safe
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
end