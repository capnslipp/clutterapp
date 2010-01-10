module DataHelpers
  
  def data_from_str(str)
    matches = /^\[([^:]+):([^:]+):([^\]]+)\]$/.match(str)
    data(matches[1], matches[2], matches[3])
  end
  
  def data(type, name, attrib)
    model = data_model(type, name)
    model.attributes[attrib.to_s]
  end
  
  def data_model(type, name)
    type = type.underscore.to_sym
    name = name.underscore.to_sym
    find_model(type, name)
  end
  
end


World(DataHelpers)
