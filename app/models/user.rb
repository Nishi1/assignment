class User < ApplicationRecord
  default_scope { where(status: true) }
  has_many :user_reporters, dependent: :destroy
  accepts_nested_attributes_for :user_reporters, allow_destroy: true

  enum user_types: [:ceo, :vp, :director, :manager, :sde]

  def soft_delete
    update_attribute(:status, false)
  end

  validates :name,
            :length   => { :minimum => 2, :maximum => 50, :message => 'Name must be greater than 2 characters and less than 50 characters' },
            presence: { :message => "Please enter name" }

  validates :email,
            :uniqueness => { :message => "Email already exist" },
            :presence   => { :message => "Please enter email" }

  validates :salary,
            presence: { :message => "Please enter salary" }

  validates :status,
            inclusion: { in: [true, false] }

end
