class FormEmailer < ApplicationMailer
  default :from => 'noreply@lrxd.com'
  default :to => ENV['SEND_TO_EMAIL']

  def send_form_email(form_name, form_url, form_data, domain=nil)
    @form_name = form_name
    @form_url = form_url
    @form_data = form_data
    @from = domain.blank? ? "noreply@lrxd.com" : "noreply@" + domain.to_s

    mail(from: @from, subject: "New submission from " + form_name.to_s)
  end
end
