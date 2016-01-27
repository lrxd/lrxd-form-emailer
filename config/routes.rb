Rails.application.routes.draw do
  root to: "email#index"

  post "/" => "email#form_submission"
end
