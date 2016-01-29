class FormEmailer < ApplicationMailer
  default :from => 'noreply@lrxd.com'
  default :to => ENV['SEND_TO_EMAIL']

  def send_form_email(form_name, form_url, form_data, domain=nil)
    @form_name = form_name
    @form_url = form_url
    @form_data = form_data

    # Attachments
    allowed_types = ['application/pdf', 'image/jpeg', 'application/msword', 'image/tiff', 'image/x-tiff', 'application/postscript']
    if !@form_data[:proof_upload].blank? && allowed_types.include?(@form_data[:proof_upload].content_type)
      @attachment = @form_data.delete('proof_upload')
      attachments[@attachment.original_filename.to_s] = @attachment.tempfile.read
    elsif !@form_data[:proof_upload].blank?
      @form_data.delete('proof_upload')
    end

    @from = domain.blank? ? "noreply@lrxd.com" : "noreply@" + domain.to_s

    # Reply to emails, why not
    if !@form_data[:email].blank?
      @reply_to = @form_data[:email]
    else
      @reply_to = @from
    end

    mail(from: @from, reply_to: @reply_to, subject: "New submission from " + @form_name.to_s)
  end
end
