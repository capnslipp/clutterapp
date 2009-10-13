class Hash
  
  def to_s(format = nil)
    if format == :nice
      self.to_a.collect{|p| "#{p[0]}: #{p[1]}" }.join('; ')
    else
      super()
    end
  end
  
end