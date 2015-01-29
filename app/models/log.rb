class Log < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :student
  before_save :check_student_id
  after_save :set_absences, unless: :flag?
  validates :date, presence: true
  validates :lesson_id, presence: true, numericality: {only_integer: true}
  validates :student_id, presence: true, numericality: {only_integer: true}

  private
  def check_student_id
    unless Student.exists?(self.student_id)
      false
    end
  end

  def set_absences
    row = Absence.find_by(student_id: self.student_id, lesson_id: self.lesson_id)
    row.amount+=2
    row.save
  end
end
