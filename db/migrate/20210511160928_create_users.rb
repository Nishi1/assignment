class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
    	t.integer :user_type_id
    	t.string :name
    	t.string :email
    	t.decimal :salary, precision: 10, scale: 2
    	t.boolean :status, default: true
      	t.timestamps null: false
    end
  end
end
