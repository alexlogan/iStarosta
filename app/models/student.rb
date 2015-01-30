class Student < ActiveRecord::Base
  has_many :medical_certificates, dependent: :destroy
  has_many :logs, dependent: :delete_all
  has_many :absences, dependent: :delete_all

  after_create :create_absence
  after_create :create_logs
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

  def create_logs
    if Log.any?
      lessons_log = Log.select(:lesson_id).distinct
      lessons_log.each_with_index do |lesson_log|
        dates_log = Log.where(lesson_id: lesson_log.lesson_id).group(:date)
        dates_log.each do |date_log|
          Log.create({
              student_id: self.id,
              lesson_id: lesson_log.lesson_id,
              flag: false,
              date: date_log.date
            })
        end
      end

    end
  end
end
