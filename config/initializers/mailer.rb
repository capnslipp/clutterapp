ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.default_charset = 'utf-8'
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.sendmail_settings = {
  :location       => '/usr/sbin/sendmail',
  :arguments      => '-i -t'
}
