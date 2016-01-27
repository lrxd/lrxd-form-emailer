class FormEmailer < ApplicationMailer
  default :from => 'noreply@lrxd.com'
  default :to => ENV['SEND_TO_EMAIL']

  def send_form_email(form_name, form_url, form_data)
    @form_name = form_name
    @form_url = form_url
    @form_data = form_data

    mail(subject: form_name.to_s + " submission from " + form_url.to_s)
  end
end
