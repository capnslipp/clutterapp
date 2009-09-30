module RouteHelper
  
# user -> piles
  
  # two scoops
  def piles_url(r_h_a, options = {})
    record = devise_record(r_h_a)
    user_piles_url(options.merge user_id_from_user( record.instance_of?(Pile) ? record.owner : record ))
  end
  def piles_path(r_h_a, options = {})
    record = devise_record(r_h_a)
    user_piles_path(options.merge user_id_from_user( record.instance_of?(Pile) ? record.owner : record ))
  end
  
  # one scoop
  def pile_url(r_h_a, options = {})
    user_pile_url(id_and_user_id_from_pile( devise_record(r_h_a) ), options)
  end
  def pile_path(r_h_a, options = {})
    user_pile_path(id_and_user_id_from_pile( devise_record(r_h_a) ), options)
  end
  
  # strawberry
  def edit_pile_url(r_h_a, options = {})
    edit_user_pile_url(id_and_user_id_from_pile( devise_record(r_h_a) ), options)
  end
  def edit_pile_path(r_h_a, options = {})
    edit_user_pile_path(id_and_user_id_from_pile( devise_record(r_h_a) ), options)
  end
  
  # chocolate
  def new_pile_url(r_h_a, options = {})
    new_user_pile_url(user_id_from_user( devise_record(r_h_a).owner ), options)
  end
  def new_pile_path(r_h_a, options = {})
    new_user_pile_path(user_id_from_user( devise_record(r_h_a).owner ), options)
  end
  
  
# user -> pile -> nodes
  
  # two waffle cones
  def nodes_url(r_h_a, options = {})
    record = devise_record(r_h_a)
    user_pile_nodes_url(options.merge pile_id_and_user_id_from_pile( record.instance_of?(Node) ? record.pile : record ))
  end
  def nodes_path(r_h_a, options = {})
    record = devise_record(r_h_a)
    user_pile_nodes_path(options.merge pile_id_and_user_id_from_pile( record.instance_of?(Node) ? record.pile : record ))
  end
  
  # one waffle cone
  def node_url(r_h_a, options = {})
    user_pile_node_url(id_and_pile_id_and_user_id_from_node( devise_record(r_h_a) ), options)
  end
  def node_path(r_h_a, options = {})
    user_pile_node_path(id_and_pile_id_and_user_id_from_node( devise_record(r_h_a) ), options)
  end
  
  # dipped waffle cone
  def edit_node_url(r_h_a, options = {})
    edit_user_pile_node_url(id_and_pile_id_and_user_id_from_node( devise_record(r_h_a) ), options)
  end
  def edit_node_path(r_h_a, options = {})
    edit_user_pile_node_path(id_and_pile_id_and_user_id_from_node( devise_record(r_h_a) ), options)
  end
  
  # a waffle cone for your little brother
  def move_node_url(r_h_a, options = {})
    move_user_pile_node_url(id_and_pile_id_and_user_id_from_node( devise_record(r_h_a) ), options)
  end
  def move_node_path(r_h_a, options = {})
    move_user_pile_node_path(id_and_pile_id_and_user_id_from_node( devise_record(r_h_a) ), options)
  end
  
  # spinkled waffle cone
  def new_node_url(r_h_a, options = {})
    new_user_pile_node_url(pile_id_and_user_id_from_pile( devise_record(r_h_a).pile ), options)
  end
  def new_node_path(r_h_a, options = {})
    new_user_pile_node_path(pile_id_and_user_id_from_pile( devise_record(r_h_a).pile ), options)
  end
  
  
protected
  
  def devise_record(record_or_hash_or_array)
    case record_or_hash_or_array
      when Hash:  record_or_hash_or_array[:id]
      when Array: record_or_hash_or_array[0]
      else        record_or_hash_or_array
    end
  end
  
  
  # for piles
  
  def user_id_from_user(user)
    { :user_id => user }
  end
  
  def id_and_user_id_from_pile(pile)
    { :id => pile, :user_id => pile.owner }
  end
  
  
  # for nodes
  
  def pile_id_and_user_id_from_pile(pile)
    { :pile_id => pile, :user_id => pile.owner }
  end
  
  def id_and_pile_id_and_user_id_from_node(node)
    { :id => node, :pile_id => node.pile, :user_id => node.pile.owner }
  end
  
end
