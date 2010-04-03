create_table :clubs, :force => true do |t|
  t.string :name
end

create_table :sponsors, :force => true do |t|
  t.integer :club_id
  t.integer :sponsorable_id
  t.string :sponsorable_type
end

create_table :men, :force => true do |t|
  t.string  :name
end

create_table :faces, :force => true do |t|
  t.string  :description
  t.integer :man_id
  t.integer :polymorphic_man_id
  t.string :polymorphic_man_type
end

create_table :interests, :force => true do |t|
  t.string :topic
  t.integer :man_id
  t.integer :polymorphic_man_id
  t.string :polymorphic_man_type
  t.integer :zine_id
end

create_table :zines, :force => true do |t|
  t.string :title
end
