ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
:enable_starttls_auto => true,
:address => "smtp.gmail.com",
:port => 587,
:domain => "joshuavera.net",
:authentication => :plain,
:user_name => "do-not-reply@joshuavera.net",
:password => "2825C9"
}