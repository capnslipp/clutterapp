module Colorist
  # Color is the general class for storing and manipulating a color with the
  # Colorist gem. It provides methods to add, subtract, and calculate aspects
  # of the color based on W3C and other standards.
  class Color
    attr_accessor :r, :g, :b, :a
    
    CSS_COLOR_NAMES = {  "maroon"  => 0x800000,
                         "red"     => 0xff0000,
                         "orange"  => 0xffa500,
                         "yellow"  => 0xffff00,
                         "olive"   => 0x808000,
                         "purple"  => 0x800080,
                         "fuchsia" => 0xff00ff,
                         "white"   => 0xffffff,
                         "lime"    => 0x00ff00,
                         "green"   => 0x008000,
                         "navy"    => 0x000080,
                         "blue"    => 0x0000ff,
                         "aqua"    => 0x00ffff,
                         "teal"    => 0x008080,
                         "black"   => 0x000000,
                         "silver"  => 0xc0c0c0,
                         "gray"    => 0x808080  }
    
    # Creates a new color with the hex color provided as a number (i.e. 0x112233)
    def initialize(color = 0x000000, alpha = 1.0)
      string = "%.6x" % color
      @r = string[0..1].hex
      @g = string[2..3].hex
      @b = string[4..5].hex
      @a = alpha
    end
    
    # Initialize a color based on RGB values. By default, the values
    # should be between 0 and 255. If you use the option <tt>:percent => true</tt>,
    # the values should then be between 0.0 and 1.0.
    def self.from_rgb(r, g, b, options = {})
      color = new
      # convert from 0.0 to 1.0 to 0 to 255 if the :percent option is used
      if options[:percent]
        color.r, color.g, color.b = (r * 255).round, (g * 255).round, (b * 255).round
      else
        color.r, color.g, color.b = r, g, b
      end
      color
    end
    
    def self.from_rgba(r, g, b, a, options = {})
      color = from_rgb(r, g, b, options)
      color.a = a
      color
    end
    
    # Initialize a colour based on HSV/HSB values. Hue should be between 0 and 360 (inclusive),
    # while saturation and value should be from 0.0 to 1.0.
    def self.from_hsv(hue, saturation, value)
      saturation = 1 if saturation > 1
      value = 1 if saturation > 1
      
      # Conversion formula taken from wikipedia
      
      f = (hue / 60.0) - (hue / 60).floor
      
      p = value * (1 - saturation)
      q = value * (1 - (saturation * f))
      t = value * (1 - (saturation * (1 - f)))
      
      r, g, b = case (hue / 60).floor % 6
                when 0 then [ value, t, p ]
                when 1 then [ q, value, p ]
                when 2 then [ p, value, t ]
                when 3 then [ p, q, value ]
                when 4 then [ t, p, value ]
                when 5 then [ value, p, q ]
                end
      
      from_rgb(r, g, b, :percent => true)
    end
    
    def self.from_hsva(hue, saturation, value, alpha)
      color = from_hsv(hue, saturation, value)
      color.a = alpha
      color
    end
    
    # Converts a CSS hex string into a color. Works both with the
    # full form (i.e. <tt>#ffffff</tt>) and the abbreviated form (<tt>#fff</tt>). Can
    # also take any of the 16 named CSS colors.
    def self.from_string(some_string)
      if matched = some_string.match(/\A#([0-9a-f]{3})\z/i)
        color = from_rgb(*matched[1].split(//).collect{|v| "#{v}#{v}".hex })
      elsif matched = some_string.match(/\A#([0-9a-f]{6})\z/i)
        color = new
        color.r = matched[1][0..1].hex
        color.g = matched[1][2..3].hex
        color.b = matched[1][4..5].hex
      elsif CSS_COLOR_NAMES.key?(some_string)
        color = new(CSS_COLOR_NAMES[some_string])
      else
        raise ArgumentError, "Must provide a valid CSS hex color or color name.", caller
      end
      color
    end
    
    # Create a new color from the provided object. Duplicates Color objects
    # and attempts to call <tt>to_color</tt> on other objects. Will raise
    # an ArgumentError if it is unable to coerce the color.
    def self.from(some_entity)
      case some_entity
        when Colorist::Color
          some_entity.dup
        else
          raise ArgumentError, "#{some_entity.class.to_s} cannot be coerced into a color.", caller unless some_entity.respond_to?(:to_color)
          some_entity.to_color
      end
    end
    
    # Create a duplicate of this color.
    def dup
      self.class.from_rgba(@r, @g, @b, @a)
    end
    
    # Add the individual RGB values of two colors together.
    # You may also use an equivalent numeric or string color representation.
    # The alpha value is kept from the original color (left-hand side).
    #
    # Examples:
    #
    #   gray = Colorist::Color.new(0x333333)
    #   gray + "#300"   # => <Color #663333>
    #   gray + 0x000000 # => <Color #333333>
    #   white = "white".to_color
    #   gray + white    # => <Color #ffffff>
    def +(other_color)
      other_color = self.class.from(other_color)
      color = self.dup
      color.r += other_color.r
      color.g += other_color.g
      color.b += other_color.b
      color
    end
    
    # Subtract the individual RGB values of the two colors together.
    # You may also use an equivalent numeric or string color representation.
    # The alpha value is kept from the original color (left-hand side).
    def -(other_color)
      other_color = self.class.from(other_color)
      color = self.dup
      color.r -= other_color.r
      color.g -= other_color.g
      color.b -= other_color.b
      color
    end
    
    # Multiply the individual RGB values of two colors together or against a Float.
    # Colors divided in a way that is equivalent to each of the values being normalized to 0.0..1.0 prior to the operation
    #   and normalized back to 0.0..255.0 after the operation.
    # You may also use an equivalent numeric or string color representation.
    # The alpha value is kept from the original color (left-hand side).
    def *(other)
      color = self.dup
      
      if other.is_a? Float
        color.r *= other
        color.g *= other
        color.b *= other
      else
        other_color = self.class.from(other)
        color.r = color.r * other_color.r / 255.0
        color.g = color.g * other_color.g / 255.0
        color.b = color.b * other_color.b / 255.0
      end
      
      color
    end
    
    # Divide the individual RGB values of the two colors together or against a Float.
    # Colors divided in a way that is equivalent to each of the values being normalized to 0.0..1.0 prior to the operation
    #   and normalized back to 0.0..255.0 after the operation.
    # You may also use an equivalent numeric or string color representation.
    # The alpha value is kept from the original color (left-hand side).
    def /(other)
      color = self.dup
      
      if other.is_a? Float
        color.r /= other
        color.g /= other
        color.b /= other
      else
        other_color = self.class.from(other)
        color.r = color.r / other_color.r * 255.0
        color.g = color.g / other_color.g * 255.0
        color.b = color.b / other_color.b * 255.0
      end
      
      color
    end
    
    # Compares colors based on brightness.
    def <=>(other_color)
      other_color = self.class.from(other_color)
      brightness <=> other_color.brightness
    end
    
    # Compares colors based on brightness.
    def < (other_color)
      other_color = self.class.from(other_color)
      brightness < other_color.brightness
    end
    
    # Compares colors based on brightness.
    def > (other_color)
      other_color = self.class.from(other_color)
      brightness > other_color.brightness
    end
    
    # Equal if the red, green, blue, and alpha values are identical.
    def ==(other_color)
      other_color = self.class.from(other_color)
      other_color.r == self.r && other_color.g == self.g && other_color.b == self.b && other_color.a == self.a
    end
    
    # Equal if the brightnesses of the two colors are identical.
    def ===(other_color)
      other_color = self.class.from(other_color)
      other_color.brightness == brightness
    end
    
    def r=(value) #:nodoc:
      @r = value; normalize; end
    def g=(value) #:nodoc:
      @g = value; normalize; end
    def b=(value) #:nodoc:
      @b = value; normalize; end
    def a=(value) #:nodoc:
      @a = value; normalize; end
    
    # Outputs a string representation of the color in the desired format.
    # The available formats are:
    #
    # * <tt>:css</tt> - As a CSS hex string (i.e. <tt>#ffffff</tt>) (default)
    # * <tt>:css_rgb</tt> - As a CSS RGB value string (i.e. <tt>rgb(255, 255, 255)</tt>)
    # * <tt>:css_rgba</tt> - As a CSS RGBA value string (i.e. <tt>rgb(255, 255, 255, 1.0)</tt>)
    # * <tt>:rgb</tt> - As an RGB triplet (i.e. <tt>1.0, 1.0, 1.0</tt>)
    # * <tt>:rgba</tt> - As an RGBA quadruplet (i.e. <tt>1.0, 1.0, 1.0, 1.0</tt>)
    def to_s(format=:css)
      case format
        when :css
          "#%.2x%.2x%.2x" % [r, g, b]
        when :css_rgb
          "rgb(%d, %d, %d)" % [r, g, b]
        when :css_rgba
          "rgba(%d, %d, %d, %.3f)" % [r, g, b, a]
        when :rgb
          "%.3f, %.3f, %.3f" % [r / 255, g / 255, b / 255]
        when :rgba
          "%.3f, %.3f, %.3f, %.3f" % [r / 255, g / 255, b / 255, a / 255]
      end
    end
    
    # Returns an array of the hue, saturation and value of the color.
    # Hue will range from 0-359, hue and saturation will be between 0 and 1.
    
    def to_hsv
      red, green, blue = *[r, g, b].collect {|x| x / 255.0}
      max = [red, green, blue].max
      min = [red, green, blue].min
      
      if min == max
        hue = 0
      elsif max == red
        hue = 60 * ((green - blue) / (max - min))
      elsif max == green
        hue = 60 * ((blue - red) / (max - min)) + 120
      elsif max == blue
        hue = 60 * ((red - green) / (max - min)) + 240
      end
      
      saturation = (max == 0) ? 0 : (max - min) / max
      [hue % 360, saturation, max]
    end
    
    def inspect
      "#<Color #{to_s(:css_rgba)}>"
    end
    
    # Returns the perceived brightness of the provided color on a
    # scale of 0.0 to 1.0 based on the formula provided. The formulas
    # available are:
    #
    # * <tt>:w3c</tt> - <tt>((r * 299 + g * 587 + b * 114) / 1000 / 255</tt>
    # * <tt>:standard</tt> - <tt>sqrt(0.241 * r^2 + 0.691 * g^2 + 0.068 * b^2) / 255</tt>
    def brightness(formula = :w3c)
      case formula
        when :standard
          Math.sqrt(0.241 * r**2 + 0.691 * g**2 + 0.068 * b**2) / 255
        when :w3c
          ((r * 299 + g * 587 + b * 114) / 255000.0)
      end
    end
    
    # Contrast this color with another color using the provided formula. The
    # available formulas are:
    #
    # * <tt>:w3c</tt> - <tt>(max(r1 r2) - min(r1 r2)) + (max(g1 g2) - min(g1 g2)) + (max(b1 b2) - min(b1 b2))</tt>
    def contrast_with(other_color, formula=:w3c)
      other_color = self.class.from(other_color)
      case formula
        when :w3c
          (([self.r, other_color.r].max - [self.r, other_color.r].min) +
          ([self.g, other_color.g].max - [self.g, other_color.g].min) +
          ([self.b, other_color.b].max - [self.b, other_color.b].min)) / 765.0
      end
    end
    
    # Returns the opposite of the current color.
    def invert
      self.class.from_rgba(255 - r, 255 - g, 255 - b, a)
    end
    
    alias opposite invert
    
    # Uses a naive formula to generate a gradient between this color and the given color.
    # Returns the array of colors that make the gradient, including this color and the
    # target color.  By default will return 10 colors, but this can be changed by supplying
    # an optional steps parameter.
    def gradient_to(color, steps = 10)
      color_to = self.class.from(color)
      red = color_to.r - r
      green = color_to.g - g
      blue = color_to.b - b
      
      result = (1..(steps - 3)).to_a.collect do |step|
        percentage = step.to_f / (steps - 1)
        self.class.from_rgb(r + (red * percentage), g + (green * percentage), b + (blue * percentage))
      end
      
      # Add first and last colors to result, avoiding uneccessary calculation and rounding errors
      
      result.unshift(self.dup)
      result.push(color.dup)
      result
    end
    
    # Converts the current color to grayscale using the brightness
    # formula provided. See #brightness for a description of the
    # available formulas.
    def to_grayscale(formula = :w3c)
      b = brightness(formula)
      self.class.from_rgb(255 * b, 255 * b, 255 * b)
    end
    
    # Returns an appropriate text color (either black or white) based on
    # the brightness of this color. The +threshold+ specifies the brightness
    # cutoff point.
    def text_color(threshold = 0.6, formula = :standard)
      brightness(formula) > threshold ? self.class.new(0x000000) : self.class.new(0xffffff)
    end
    
    # Adjusts any of H, S, V values with relative values: +opts[:h]+, +opts[:s]+, +opts[:v]+
    # and returns adjusted value.
    def adjust(opts = {})
      unless [:h, :s, :v].any? { |part| opts.include? part }
        raise ArgumentError, "please specify at least one of :h, :s, or :v options"
      end
      
      h, s, v = *self.to_hsv
      
      h = (h + opts[:h]) % 360 if opts[:h]
      s = _clamp(s + opts[:s], 0..1)   if opts[:s]
      v = _clamp(v + opts[:v], 0..1)   if opts[:v]
      
      self.class.from_hsv(h, s, v)
    end
    
    # Adjusts any of R, G, B, or A values with aboslute values: opts[:a], opts[:r], opts[:b], opts[:a]
    # and returns adjusted value.
    def with(opts = {})
      unless [:r, :g, :b, :a].any? { |part| opts.include? part }
        raise ArgumentError, "please specify at least one of :r, :g, :b, or :a options"
      end
      
      color = self.dup
      
      color.r = opts[:r] if opts[:r]
      color.g = opts[:g] if opts[:g]
      color.b = opts[:b] if opts[:b]
      color.a = opts[:a] if opts[:a]
      
      color
    end
    
    protected
    
    def normalize #:nodoc:
      @r = _clamp(@r, (0..255)) unless (0..255).include? @r
      @g = _clamp(@g, (0..255)) unless (0..255).include? @g
      @b = _clamp(@b, (0..255)) unless (0..255).include? @b
      @a = _clamp(@a, (0.0..1.0)) unless (0.0..1.0).include? @a
    end
    
    def _clamp(value, range)
      if value < range.first
        range.first
      elsif value > range.last
        range.last
      else
        value
      end
    end
    
  end # Color
  
end # Colorist
