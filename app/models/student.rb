class Student < ActiveRecord::Base
  has_many :medical_certificates, dependent: :destroy
  has_many :logs, dependent: :delete_all
  has_many :absences, dependent: :delete_all

  after_save :create_absence
  validates :name,
            presence:true,
            uniqueness: true,
            format: {
                with: /\A[а-яА-Я\s]+/,
                message: "only allows letters"
            }

  private
  def create_absence
    Lesson.all.each do |lesson|
      Absence.create({student_id: self.id, lesson_id: lesson.id, amount: 0})
    end
  end
end
