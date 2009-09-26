module RouteHelper
  
  def piles_url(options = {})
    user_piles_url(options)
  end
  
  def piles_path(options = {})
    user_piles_path(options)
  end
  
  def pile_url(r_h_a, options = {})
    user_pile_url(id_and_user_id_from_pile( devise_record(r_h_a) ), options)
  end
  
  def pile_path(r_h_a, options = {})
    user_pile_path(id_and_user_id_from_pile( devise_record(r_h_a) ), options)
  end
  
  def edit_pile_url(r_h_a, options = {})
    edit_user_pile_url(id_and_user_id_from_pile( devise_record(r_h_a) ), options)
  end
  
  def edit_pile_path(r_h_a, options = {})
    edit_user_pile_path(id_and_user_id_from_pile( devise_record(r_h_a) ), options)
  end
  
  def new_pile_url(options = {})
    new_user_pile_url(options)
  end
  
  def new_pile_path(options = {})
    new_user_pile_path(options)
  end
  
  
protected
  
  def devise_record(record_or_hash_or_array)
    case record_or_hash_or_array
      when Hash:  record_or_hash_or_array[:id]
      when Array: record_or_hash_or_array[0]
      else        record_or_hash_or_array
    end
  end
  
  def id_and_user_id_from_pile(pile)
    { :id => pile, :user_id => pile.owner }
  end
  
end
