class AddFailedBecauseToFormSubmissions < ActiveRecord::Migration
  def change
    add_column :form_submissions, :rejected_for, :text
  end
end
