class CreateUserReporters < ActiveRecord::Migration[5.2]
  def change
    create_table :user_reporters do |t|
    	t.integer :user_id
    	t.integer :reporter_id
    end
  end
end
