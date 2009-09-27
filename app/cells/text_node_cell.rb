class TextNodeCell < NodeCell
  
  def update
    @pile = @opts[:pile]
    @node = @opts[:node]
    
    @prop = @node.prop
    if @prop.update_attributes(@opts[:params][:prop])
      render :view => 'show'
    else
      render :view => 'edit'
    end
  end
  
  
protected
  
  def new_prop
    TextProp.new(:pile => @pile)
  end
end
