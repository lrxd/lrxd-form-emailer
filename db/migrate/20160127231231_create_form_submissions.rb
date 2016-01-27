class CreateFormSubmissions < ActiveRecord::Migration
  def change
    create_table :form_submissions do |t|
      t.string :form_name, null: false
      t.string :referer, null: false
      t.string :callback
      t.hstore :form_data, null: false
      t.boolean :email_sent
      t.timestamps null: false
    end
  end
end
