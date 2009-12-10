ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_charset = 'utf-8'
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => 'localhost',
  :port => 25,
  :domain => 'clutterapp.com',
  :user_name => 'knock-knock.whos-there.no-one.no-one-who@clutterapp.com',
  #:password => '???',
  :authentication => :plain,
}
