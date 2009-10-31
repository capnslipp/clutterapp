require 'factory_girl/syntax/blueprint' # definition syntax similar to Machinist
require 'factory_girl/syntax/generate' # usage syntax similar to Object Daddy
require 'factory_girl/syntax/make' # usage syntax similar to Machinist
require 'factory_girl/syntax/sham' # sequence syntax similar to Machinist


Factory.define :invite do |f|
  f.sequence(:recipient_email) { |i_n| "invite_#{i_n}@example.com" }
end


Factory.define :user do |f|
  f.sequence(:login) { |u_n| "user_#{u_n}" }
  f.password 'p4ssword'
  f.password_confirmation { |u| u.password }
  f.sequence(:email) { |u_n| "user_#{u_n}@example.com" }
  f.association :invite
end


Factory.define :pile do |f|
  f.sequence(:name) { |u_n| "Pile #{u_n}" }
  f.association :owner, :factory => :user
end


Factory.define :node do |f|
  f.association :pile
  f.association :prop, :factory => :text_prop
end


Factory.define :text_prop do |f|
  f.text 'test text'
end
