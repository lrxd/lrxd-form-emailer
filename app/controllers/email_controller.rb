class EmailController < ApplicationController
  def index
    render
  end

  def form_submission
    submission = form_params

    referer_uri = URI.parse(submission[:referer])
    if !submission[:callback].blank?
      callback_uri = URI.parse(submission[:callback])
    end

    if params[:name].blank? && params[:email].blank?
      submission[:email_sent] = true
      begin
        FormEmailer.send_form_email(submission[:form_name], submission[:referer], submission[:form_data], referer_uri.host).deliver_now
      rescue => e
        p "*" * 80
        pp e
        p "*" * 80
        submission[:email_sent] = false
        submission[:rejected_for] = e.to_s
      end

      FormSubmission.create(submission)

      redirect_to ((submission[:callback].blank? ? submission[:referer] : submission[:callback]) + "?submitted=" + submission[:email_sent].to_s)
    else
      submission[:email_sent] = false
      submission[:rejected_for] = "honeypot"

      FormSubmission.create(submission)

      redirect_to ((submission[:callback].blank? ? submission[:referer] : submission[:callback]) + "?submitted=" + submission[:email_sent].to_s)
    end
  end


  private
    def form_params
      params.require(:form_name)
      params.require(:referer)
      params.require(:form_data)
      params.permit(:form_name, :referer, :callback).tap do |whitelisted|
        whitelisted[:form_data] = params[:form_data]
      end
    end
end
