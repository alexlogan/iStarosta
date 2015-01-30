class Lesson < ActiveRecord::Base
  has_many :logs, dependent: :delete_all
  has_many :absence, dependent: :delete_all

  after_save :create_absence
  validates :name,
            presence:true,
            uniqueness: true,
            format: {
              with: /\A[а-яА-Я0-9.\s]+/,
              message: "only allows letters, numbers and \".\""
            }

  private
  def create_absence
    Student.all.each do |student|
      Absence.create({student_id: student.id, lesson_id: self.id, amount: 0})
    end
  end
end