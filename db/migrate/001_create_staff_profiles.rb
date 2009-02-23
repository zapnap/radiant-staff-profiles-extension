class CreateStaffProfiles < ActiveRecord::Migration
  def self.up
    create_table :staff_profiles do |t|
      t.string   :first_name
      t.string   :last_name
      t.string   :title
      t.string   :email
      t.integer  :status_id,  :default => 1, :null => false
      t.string   :filter_id
      t.text     :biography
      t.string   :photo_file_name
      t.string   :photo_content_type
      t.integer  :photo_file_size
      t.datetime :photo_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :staff_profiles
  end
end
