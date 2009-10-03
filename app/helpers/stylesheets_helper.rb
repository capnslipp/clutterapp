module StylesheetsHelper
  include Colorist
  
  
  focus_color = '#f20'.to_color
  focus_back = focus_color.adjust(:v => 0.0).with(:a => 0.25).to_s(:css_rgba)
  focus_border = focus_color.to_s

  shadow_color = Color.from_rgba(0, 0, 0, 0.5)
  def deep_shadow(a = nil)
  	"0 2px 3px #{shadow_color.to_s(:css_rgba)}"
  end
  def shallow_shadow(a = nil)
  	"0 1.333px 2px #{shadow_color.to_s(:css_rgba)}"
  end
  def deep_shadow_decl(a = nil)
    %W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{deep_shadow};" }.join(' ')
  end
  def shallow_shadow_decl(a = nil)
  	%W{box-shadow -moz-box-shadow -webkit-box-shadow}.collect {|p| "#{p}: #{deep_shadow};" }.join(' ')
  end
  
end
