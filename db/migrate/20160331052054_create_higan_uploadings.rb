class CreateHiganUploadings < ActiveRecord::Migration
  def change
    create_table :higan_uploadings do |t|
      t.string :key, index: :unique

      t.string :path, index: :unique
      t.string :body
      t.datetime :uploaded_at
      t.datetime :source_updated_at

      t.timestamps null: false
    end
  end
end
