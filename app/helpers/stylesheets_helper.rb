module StylesheetsHelper
  include Colorist
  
  
  FOCUS_COLOR = Color.new(0xff2200)
  def focus_back
    FOCUS_COLOR.adjust(:v => 0.0).with(:a => 0.25).to_s(:css_rgba)
  end
  def focus_border
    FOCUS_COLOR.to_s
  end
  
  SHADOW_COLOR = Color.new(0x000000)
  def shadow_color(a = nil)
    Color.from_rgba(SHADOW_COLOR.r, SHADOW_COLOR.g, SHADOW_COLOR.b, a || 0.5)
  end
  def deep_shadow(a = nil)
  	"0 2px 3px #{shadow_color(a).to_s(:css_rgba)}"
  end
  def shallow_shadow(a = nil)
  	"0 1.333px 2px #{shadow_color(a).to_s(:css_rgba)}"
  end
  def deep_shadow_decl(a = nil)
    %W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{deep_shadow(a)};" }.join(' ')
  end
  def shallow_shadow_decl(a = nil)
  	%W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{deep_shadow(a)};" }.join(' ')
  end
  
end
