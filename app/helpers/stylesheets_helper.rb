module StylesheetsHelper
  include Colorist
  
  
  BG_COLOR = Color.new(0xffffff)
  def bg_color
    BG_COLOR
  end
  def text_color
    BG_COLOR.text_color
  end
  
  ACCENT_COLOR = Color.new(0xcc2200)
  def accent_color
    ACCENT_COLOR
  end
  
  WASH_COLOR = Color.new(0x666666)
  def wash_color
    WASH_COLOR
  end
  def wash_text_color
    WASH_COLOR.text_color
  end
  
  GENERIC_BORDER_COLOR = Color.new(0x000000, 0.1)
  def generic_border_color
    GENERIC_BORDER_COLOR
  end
  
  FOCUS_COLOR = ACCENT_COLOR
  def focus_back
    FOCUS_COLOR.adjust(:v => 0.0).with(:a => 0.25).to_s(:css_rgba)
  end
  def focus_border
    FOCUS_COLOR.to_s
  end
  
  SHADOW_COLOR = Color.new(0x000000, 0.5)
  def shadow_color(a = nil)
    Color.from_rgba(SHADOW_COLOR.r, SHADOW_COLOR.g, SHADOW_COLOR.b, a || SHADOW_COLOR.a)
  end
  def deep_shadow(a = nil)
  	"0px 2px 3px #{shadow_color(a).to_s(:css_rgba)}"
  end
  def shallow_shadow(a = nil)
  	"0px 1.333px 2px #{shadow_color(a).to_s(:css_rgba)}"
  end
  def deep_shadow_decl(a = nil)
    %W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{deep_shadow(a)};" }.join(' ')
  end
  def shallow_shadow_decl(a = nil)
  	%W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{deep_shadow(a)};" }.join(' ')
  end
  
  FILL_COLOR = Color.new(0xffffff, 0.75)
  def fill_color
    FILL_COLOR
  end
  
  DIVIDER_COLOR = Color.new(0xeeeeee)
  def divider_color
    DIVIDER_COLOR
  end
  
end
