require 'authlogic'


Factory.define :invite do |f|
  f.sequence(:recipient_email) { |i_n| "invite_#{i_n}@example.com" }
end

Factory.sequence :password do |n|
  "p#{n}ssword"
end

Factory.define :followship do |f|
  f.add_attribute(:followee) {|a| a.association(:user) }
  f.add_attribute(:user) {|a| a.association(:user) }
end

Factory.define :share do |f|
  f.add_attribute(:user) {|a| a.association(:user) }
  f.add_attribute(:shared_pile) {|a| a.association(:pile) }
end

Factory.define :user do |f|
  f.sequence(:login) {|u_n| "user_#{u_n}" }
  f.sequence(:email) {|u_n| "user_#{u_n}@example.com" }
  f.add_attribute(:password) { Factory.next(:password) }
  f.add_attribute(:password_confirmation) {|u| u.password}
  f.add_attribute(:password_salt) { Authlogic::Random.hex_token }
  f.add_attribute(:crypted_password) {|u| Authlogic::CryptoProviders::Sha512.encrypt(u.password + u.password_salt) }
  f.add_attribute(:persistence_token) { Authlogic::Random.hex_token }
  f.add_attribute(:single_access_token) { Authlogic::Random.friendly_token }
  f.association(:invite)
end


# Stub/mock UserSession as needed. It's much too specialized to try to generate it via Factory.
# Factory.define :user_session …


Factory.define :pile do |f|
  f.sequence(:name) { |u_n| "Pile #{u_n}" }
  f.association :owner, :factory => :user
end


Factory.define :base_node do |f|
  f.association :pile
end

Factory.define :node do |f|
  f.association :pile
  f.association :prop, :factory => :text_prop
  f.association :prop, :factory => :check_prop
  f.association :prop, :factory => :note_prop
  f.association :prop, :factory => :tag_prop
  f.association :prop, :factory => :time_prop
  f.association :prop, :factory => :priority_prop
end


Factory.define :text_prop do |f|
  f.text 'test text'
end

Factory.define :check_prop do |f|
end

Factory.define :note_prop do |f|
  f.note 'test note'
end

Factory.define :tag_prop do |f|
  f.tag 'test tag'
end

Factory.define :time_prop do |f|
  f.time Time.now
end

Factory.define :priority_prop do |f|
  f.priority 3
end
