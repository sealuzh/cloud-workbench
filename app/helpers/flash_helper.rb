module FlashHelper
  # FLASH_LEVEL: [ CLASS_TYPE, ICON ]
  FLASH_MAPPINGS = {
      notice: %w(info info),
      info:   %w(info info),
      sucess: %w(success check),
      error: %w(danger warning),
      alert: %w(danger warning)
  }

  def flash_class(level)
    FLASH_MAPPINGS[level.to_sym][0] rescue default_flash
  end

  def default_flash
    'danger'
  end

  def flash_icon(level)
    fa_icon(FLASH_MAPPINGS[level.to_sym][1]) rescue default_icon
  end

  def default_icon
    fa_icon('question')
  end
end