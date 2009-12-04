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
  
  
  BG_COLOR = '#fff'.to_color
  const_reader :bg_color
  def bright_bg_color
    bg_color.text_color.invert
  end
  def text_color
    bg_color.text_color + '#444'.to_color
  end
  
  ACCENT_COLOR = '#c30'.to_color
  const_reader :accent_color
  
  WASH_COLOR = '#444'.to_color
  const_reader :wash_color
  def wash_text_color
    wash_color.text_color
  end
  
  GENERIC_BORDER_COLOR = '#000'.to_color.with(:a => 0.2)
  def generic_border_color(m = 1.0)
    color = GENERIC_BORDER_COLOR
    color.with(:a => color.a * m)
  end
  
  BORDER_WIDTH = 1
  const_reader :border_width
  
  FOCUS_COLOR = ACCENT_COLOR
  const_reader :focus_color
  def focus_back
    focus_color.with(:a => 0.25).to_s(:css_rgba)
  end
  
  SHADOW_COLOR = '#000'.to_color.with(:a => 0.75)
  def shadow_color(alpha_multiplier_or_color = 1.0)
    if alpha_multiplier_or_color.is_a? Color
      alpha_multiplier_or_color
    elsif alpha_multiplier_or_color.is_a? String
      alpha_multiplier_or_color.to_color
    else
      color = SHADOW_COLOR
      Color.from_rgba(color.r, color.g, color.b, color.a * alpha_multiplier_or_color)
    end
  end
  def deep_shadow(alpha_multiplier_or_color = 1.0)
  	"0px 1px 6px #{shadow_color(alpha_multiplier_or_color).to_s(:css_rgba)}"
  end
  def shallow_shadow(alpha_multiplier_or_color = 1.0)
    alpha_multiplier_or_color *= 0.5 unless alpha_multiplier_or_color.is_a?(String) || alpha_multiplier_or_color.is_a?(Color)
  	"0px 1px 4px #{shadow_color(alpha_multiplier_or_color).to_s(:css_rgba)}"
  end
  def deep_shadow_decl(alpha_multiplier_or_color = 1.0)
    %W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{deep_shadow(alpha_multiplier_or_color)};" }.join(' ')
  end
  def shallow_shadow_decl(alpha_multiplier_or_color = 1.0)
  	%W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{shallow_shadow(alpha_multiplier_or_color)};" }.join(' ')
  end
  
  FILL_COLOR = '#eee'.to_color.with(:a => 0.75)
  const_reader :fill_color
  
  DIVIDER_COLOR = '#ccc'.to_color
  const_reader :divider_color
  
  WIDGET_COLOR = '#ddd'.to_color
  const_reader :widget_color
  def active_widget_color
    widget_color - '#333'.to_color
  end
  
  
  
  CSS_DIRECTION_QUARTET = [:top, :right, :bottom, :left]
  const_reader :css_direction_quartet
  
end
