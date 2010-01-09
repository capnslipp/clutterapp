module SeeingHelpers
  
  def seeing_regexp(seeing_desc, with_desc = '')
    case seeing_desc
      
      when /(?:the|a|an|my) signed-in status/
        if !with_desc
          /Logged in as.*\./
        else
          /Logged in as.*#{seeing_with(with_desc)}.*/
        end
      
      else
        raise %{Can't find mapping from "#{seeing_desc}" with "#{with_desc}" to a seeing description.}
      
    end
  end
  
  def seeing_with(with_desc)
    case with_desc
      
      when /my username/
        @user.attributes[:login]
      
      when /my name/
        @user.attributes[:name]
      
      else
        with_desc
      
    end
  end
  
end


World(SeeingHelpers)
