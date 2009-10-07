require 'const_reader'

module StylesheetsHelper
  include Colorist
  include ConstReader
  
  
  # outline-radius is not supported by WebKit; otherwise, we'd use it as well
  def border_radius_decl(size = '4px')
    "border-radius: #{size}; -moz-border-radius: #{size}; -webkit-border-radius: #{size};"
  end
  
  
  BG_COLOR = Color.new(0xffffff)
  def bg_color
    inverted? ? BG_COLOR.invert : BG_COLOR
  end
  def text_color
    bg_color.text_color
  end
  
  ACCENT_COLOR = Color.new(0xcc3300)
  def accent_color
    inverted? ? ACCENT_COLOR.invert : ACCENT_COLOR
  end
  
  WASH_COLOR = Color.new(0x666666)
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
  def focus_border
    focus_color.to_s
  end
  
  SHADOW_COLOR = Color.new(0x000000, 0.75)
  def shadow_color(m = 1.0)
    color = inverted? ? SHADOW_COLOR.invert : SHADOW_COLOR
    Color.from_rgba(color.r, color.g, color.b, color.a * m)
  end
  def deep_shadow(m = 1.0)
  	"0px 1px 6px #{shadow_color(m).to_s(:css_rgba)}"
  end
  def shallow_shadow(m = 1.0)
  	"0px 1px 4px #{shadow_color(m * 0.5).to_s(:css_rgba)}"
  end
  def deep_shadow_decl(m = 1.0)
    %W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{deep_shadow(m)};" }.join(' ')
  end
  def shallow_shadow_decl(m = 1.0)
  	%W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{shallow_shadow(m)};" }.join(' ')
  end
  
  FILL_COLOR = Color.new(0xffffff, 0.75)
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
  
  
protected
  
  def inverted?; false; end
  
end
