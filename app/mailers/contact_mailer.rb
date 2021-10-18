class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail to: ENV['SMTP_USERNAME'],subject: '【お問い合わせ】' + @contact.subject_i18n
  end
end
