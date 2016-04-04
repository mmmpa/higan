class CreateHiganUploadings < ActiveRecord::Migration
  def change
    create_table :higan_uploadings do |t|
      t.string :key, index: :unique

      t.string :path, index: :unique
      t.string :body

      t.boolean :locked, default: false, null: false
      t.boolean :public, default: true, null: false
      t.boolean :written, default: false, null: false

      t.datetime :uploaded_at
      t.datetime :source_updated_at

      t.timestamps null: false
    end
  end
end
