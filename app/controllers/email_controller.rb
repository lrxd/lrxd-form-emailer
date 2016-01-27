class EmailController < ApplicationController
  def index
    render
  end

  def form_submission
    submission = form_params
    pp submission

    submission[:email_sent] = true
    begin
      FormEmailer.send_form_email(submission[:form_name], submission[:referer], submission[:form_data]).deliver_now
    rescue
      submission[:email_sent] = false
    end

    FormSubmission.create(submission)

    redirect_to ((submission[:callback].blank? ? submission[:referer] : submission[:callback]) + "?submitted=true")
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
