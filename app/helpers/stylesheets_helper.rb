module StylesheetsHelper
  include Colorist
  
  
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
  
  GENERIC_BORDER_COLOR = Color.new(0x000000, 0.1)
  def generic_border_color
    inverted? ? GENERIC_BORDER_COLOR.invert : GENERIC_BORDER_COLOR
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
  
  SHADOW_COLOR = Color.new(0x000000, 0.5)
  def shadow_color(a = nil)
    color = inverted? ? SHADOW_COLOR.invert : SHADOW_COLOR
    Color.from_rgba(color.r, color.g, color.b, a || color.a)
  end
  def deep_shadow(a = nil)
  	"0px 3px 5px #{shadow_color(a).to_s(:css_rgba)}"
  end
  def shallow_shadow(a = nil)
  	"0px 2px 3px #{shadow_color(a).to_s(:css_rgba)}"
  end
  def deep_shadow_decl(a = nil)
    %W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{deep_shadow(a)};" }.join(' ')
  end
  def shallow_shadow_decl(a = nil)
  	%W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{shallow_shadow(a)};" }.join(' ')
  end
  
  FILL_COLOR = Color.new(0xffffff, 0.75)
  def fill_color
    inverted? ? FILL_COLOR.invert : FILL_COLOR
  end
  
  DIVIDER_COLOR = Color.new(0xeeeeee)
  def divider_color
    inverted? ? DIVIDER_COLOR.invert : DIVIDER_COLOR
  end
  
  
protected
  
  def inverted?; false; end
  
end
