require 'factory_girl/syntax/blueprint' # definition syntax similar to Machinist
require 'factory_girl/syntax/generate' # usage syntax similar to Object Daddy
require 'factory_girl/syntax/make' # usage syntax similar to Machinist
require 'factory_girl/syntax/sham' # sequence syntax similar to Machinist
require 'authlogic'

Factory.define :invite do |f|
  f.sequence(:recipient_email) { |i_n| "invite_#{i_n}@example.com" }
end

Factory.sequence :password do |n|
  "p#{n}ssword"
end


# Factory.define :user do |f|
#   f.sequence(:login) { |u_n| "user_#{u_n}" }
#   f.password 'p4ssword'
#   f.password_confirmation { |u| u.password }
#   f.sequence(:email) { |u_n| "user_#{u_n}@example.com" }
#   f.association :invite
# end

Factory.define :user do |f|
  f.sequence(:login) { |u_n| "user_#{u_n}" }
  f.sequence(:email) {|u_n| "user_#{u_n}@example.com" }
  f.password {Factory.next(:password)}
  f.password_confirmation {|u| u.password}
  f.password_salt {Authlogic::Random.hex_token}
  f.crypted_password { |u| Authlogic::CryptoProviders::Sha512.encrypt(u.password + u.password_salt) }
  f.persistence_token { Authlogic::Random.hex_token}
  f.single_access_token {Authlogic::Random.friendly_token}
  f.association :invite
end


# Stub/mock UserSession as needed. It's much too specialized to try to generate it via Factory.
# Factory.define :user_session …


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
