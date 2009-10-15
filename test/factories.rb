Factory.define :user do |f|
  f.sequence(:login) { |n| "user_#{n}" }
  f.password "p4ssword"
  f.password_confirmation { |u| u.password }
  f.sequence(:email) { |n| "user_#{n}@example.com" }
  f.association(:invite)
end


Factory.define :invite do |f|
  f.sequence(:recipient_email) { |n| "invite_#{n}@example.com" }
end
