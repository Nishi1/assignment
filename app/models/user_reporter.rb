class UserReporter < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :reporter, class_name: :User, foreign_key: :reporter_id

  before_validation :validate_ceo, :validate_sde

  #CEO can not report to anybody
  def validate_ceo
    if self.user.user_type_id == User.user_types['ceo']
      self.errors.add(:reportee_id, 'You can not mark CEO as reportee')
      return false
    end
  end

  #Nobody can report to SDE
  def validate_sde
    user = self.reporter
    if user.present? && user.user_type_id == User.user_types['sde']
      self.errors.add(:user_id, 'Employees can not report to SDE')
      return false
    end
  end

  validates :reporter_id,
            presence: { :message => "Please enter reporter" }
end
