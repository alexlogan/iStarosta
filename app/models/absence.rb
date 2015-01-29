class Absence < ActiveRecord::Base
  belongs_to :student
  belongs_to :lesson
  validates :lesson_id, presence: true, numericality: {only_integer: true}
  validates :student_id, presence: true, numericality: {only_integer: true}
  validates :amount, presence: true, numericality: {only_integer: true}

end
