class NodesDataset < Dataset::Base
  uses :piles
  
  def load
    set_up_a_pile
    set_up_a_better_pile
    set_up_another_pile
  end
  
  
  def set_up_a_pile
    create_node :a_plain_text_node, :with => {
      :parent => piles(:a_pile).root_node,
      :prop => TextProp.new(:value => 'something to say…')
    }
    
    create_node :a_sub_pile_ref_node, :with => {
      :parent => piles(:a_pile).root_node,
      :prop => PileRefProp.new(:value => piles(:a_better_pile))
    }
    
    create_node :a_todo_node, :with => {
      :parent => piles(:a_pile).root_node,
      :prop => TextProp.new(:value => 'make pie'),
      :children => [
        Node.new(:prop => CheckProp.new)
      ]
    }
    
    create_node :a_sub_todo_node, :with => {
      :parent => nodes(:a_todo_node),
      :prop => TextProp.new(:value => 'buy ingredients'),
      :children => [
        Node.new(:prop => CheckProp.new)
      ]
    }
    
    create_node :a_sub_sub_todo_node, :with => {
      :parent => nodes(:a_sub_todo_node),
      :prop => TextProp.new(:value => 'bake shit up'),
      :children => [
        Node.new(:prop => CheckProp.new)
      ]
    }
    
    create_node :a_prioritized_todo_node, :with => {
      :parent => piles(:a_pile).root_node,
      :prop => TextProp.new(:value => 'eat fud'),
      :children => [
        Node.new(:prop => CheckProp.new),
        Node.new(:prop => PriorityProp.new(:value => 3))
      ]
    }
    
    create_node :a_tagged_todo_node, :with => {
      :parent => piles(:a_pile).root_node,
      :prop => TextProp.new(:value => 'rule teh world'),
      :children => [
        Node.new(:prop => CheckProp.new),
        Node.new(:prop => TagProp.new(:value => 'hypothetical'))
      ]
    }
    
    create_node :a_multitagged_todo_node, :with => {
      :parent => piles(:a_pile).root_node,
      :prop => TextProp.new(:value => 'be happy for ever'),
      :children => [
        Node.new(:prop => CheckProp.new),
        Node.new(:prop => TagProp.new(:value => 'hypothetical')),
        Node.new(:prop => TagProp.new(:value => 'stereotypical')),
        Node.new(:prop => TagProp.new(:value => 'ideal'))
      ]
    }
    
    create_node :a_dated_todo_node, :with => {
      :parent => piles(:a_pile).root_node,
      :prop => TextProp.new(:value => 'the future is here'),
      :children => [
        Node.new(:prop => CheckProp.new),
        Node.new(:prop => TimeProp.new(:value => Date.new(2010)))
      ]
    }
    
    create_node :a_noted_todo_node, :with => {
      :parent => piles(:a_pile).root_node,
      :prop => TextProp.new(:value => 'a little story for you'),
      :children => [
        Node.new(:prop => CheckProp.new),
        Node.new(:prop => NoteProp.new(:value => <<-EOS
#  EnameledKoi
Waiting for large pots of coffee to brew at @eastlakecc Bellevue at Newport High School about 4 hours ago from Loopt

# HamletDRC HamletDRC
60 Second Agility: ROTI Meetings http://bit.ly/77n4Wh about 10 hours ago from TweetDeck

# Russell Andes russish
Seeing An Education, completely alone in the theatre. Gotta love arthouse flicks in their last weeks of release. about 15 hours ago from Twitterrific

# Cassie Townsend CassieTownsend
Want to see my new hair color? Come to the show tonight! about 17 hours ago from Echofon

# Joshua Vera joshvera
What Gandalf said about a company of 13. about 19 hours ago from Tweetie

# Justin shitmydadsays
"Been thinking for a while, and I'd say there's 1.5 pounds of shit in the dog. Tried to get the vet to weigh a sack of it. No dice." 12:02 PM Jan 9th from web
EOS
        ))
      ]
    }
    
    create_node :a_prioritzed_tagged_dated_noted_todo_node, :with => {
      :parent => piles(:a_pile).root_node,
      :prop => TextProp.new(:value => 'finish ClutterApp'),
      :children => [
        Node.new(:prop => CheckProp.new),
        Node.new(:prop => PriorityProp.new(:value => 2)),
        Node.new(:prop => TagProp.new(:value => 'awesome')),
        Node.new(:prop => TimeProp.new(:value => Date.new(2010))),
        Node.new(:prop => NoteProp.new(:value => "This is really important; this means something."))
      ]
    }
  end
  
  def set_up_a_better_pile
    create_node :a_better_plain_text_node, :with => {
      :parent => piles(:a_better_pile).root_node,
      :prop => TextProp.new(:value => 'something better to say…')
    }
  end
  
  def set_up_another_pile
    create_node :another_plain_text_node, :with => {
      :parent => piles(:another_pile).root_node,
      :prop => TextProp.new(:value => 'something else to say…')
    }
  end
    
  
  helpers do
    
    def create_node(dataset_name, opts = {})
      u = Node.create! opts[:with]
      name_model u, dataset_name
    end
    
    def name_node(dataset_name, opts = {})
      name_model opts[:for], dataset_name
    end
    
  end
  
end
