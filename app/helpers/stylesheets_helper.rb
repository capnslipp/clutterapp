require 'const_reader'

module StylesheetsHelper
  include Colorist
  include ConstReader
  
  
  def debug?
    App::Config.debug_style
  end
  
  
  
  # outline-radius is not supported by WebKit; otherwise, we'd use it as well
  def border_radius_decl(size = '4px')
    "border-radius: #{size}; -moz-border-radius: #{size}; -webkit-border-radius: #{size};"
  end
  
  
  BG_COLOR = Color.new(0xf6f6f6)
  def bg_color
    inverted? ? BG_COLOR.invert : BG_COLOR
  end
  def bright_bg_color
    bg_color.text_color.invert
  end
  def text_color
    bg_color.text_color
  end
  
  ACCENT_COLOR = Color.new(0xcc3300)
  def accent_color
    inverted? ? ACCENT_COLOR.invert : ACCENT_COLOR
  end
  
  WASH_COLOR = Color.new(0x444444)
  def wash_color
    inverted? ? WASH_COLOR.invert : WASH_COLOR
  end
  def wash_text_color
    wash_color.text_color
  end
  
  GENERIC_BORDER_COLOR = Color.new(0x000000, 0.2)
  def generic_border_color(m = 1.0)
    color = inverted? ? GENERIC_BORDER_COLOR.invert : GENERIC_BORDER_COLOR
    color.with(:a => color.a * m)
  end
  
  BORDER_WIDTH = 1
  def border_width
    BORDER_WIDTH
  end
  
  FOCUS_COLOR = ACCENT_COLOR
  def focus_color
    inverted? ? FOCUS_COLOR.invert : FOCUS_COLOR
  end
  def focus_back
    focus_color.with(:a => 0.25).to_s(:css_rgba)
  end
  
  SHADOW_COLOR = Color.new(0x000000, 0.75)
  def shadow_color(alpha_multiplier_or_color = 1.0)
    if alpha_multiplier_or_color.is_a? Color
      alpha_multiplier_or_color
    elsif alpha_multiplier_or_color.is_a? String
      alpha_multiplier_or_color.to_color
    else
      color = inverted? ? SHADOW_COLOR.invert : SHADOW_COLOR
      Color.from_rgba(color.r, color.g, color.b, color.a * alpha_multiplier_or_color)
    end
  end
  def deep_shadow(alpha_multiplier_or_color = 1.0)
  	"0px 2px 6px #{shadow_color(alpha_multiplier_or_color).to_s(:css_rgba)}"
  end
  def shallow_shadow(alpha_multiplier_or_color = 1.0)
    alpha_multiplier_or_color *= 0.5 unless alpha_multiplier_or_color.is_a?(String) || alpha_multiplier_or_color.is_a?(Color)
  	"0px 1px 3px #{shadow_color(alpha_multiplier_or_color).to_s(:css_rgba)}"
  end
  def deep_shadow_decl(alpha_multiplier_or_color = 1.0)
    %W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{deep_shadow(alpha_multiplier_or_color)};" }.join(' ')
  end
  def shallow_shadow_decl(alpha_multiplier_or_color = 1.0)
  	%W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{shallow_shadow(alpha_multiplier_or_color)};" }.join(' ')
  end
  
  FILL_COLOR = Color.new(0xeeeeee, 0.75)
  def fill_color
    inverted? ? FILL_COLOR.invert : FILL_COLOR
  end
  
  DIVIDER_COLOR = Color.new(0xcccccc)
  def divider_color
    inverted? ? DIVIDER_COLOR.invert : DIVIDER_COLOR
  end
  
  WIDGET_COLOR = Color.new(0xdddddd)
  def widget_color
    inverted? ? WIDGET_COLOR.invert : WIDGET_COLOR
  end
  def active_widget_color
    inverted? ? widget_color + Color.new(0x333333) : widget_color - Color.new(0x333333)
  end
  
  
  
  CSS_DIRECTION_QUARTET = [:top, :right, :bottom, :left]
  const_reader :css_direction_quartet
  
  
  def opacity(val)
    val = val.to_f
    ie_val = (val * 100).to_i
    "-ms-filter:'progid:DXImageTransform.Microsoft.Alpha(Opacity=#{ie_val})'; filter: alpha(opacity=#{ie_val}); opacity: #{val}"
  end
  
  
protected
  
  def inverted?; false; end
  
end
