module PilesHelper
  
  def observable_partial_path(original_path)
    trimmed_path = original_path.sub(/^nodes\//, '')
    path = "piles/observable/#{trimmed_path}"
  end
  
  def modifiable_partial_path(original_path)
    trimmed_path = original_path.sub(/^nodes\//, '')
    path = "piles/modifiable/#{trimmed_path}"
  end
  
end
