class Student < ActiveRecord::Base
  belongs_to :group
  has_many :medical_certificates, dependent: :destroy
  has_many :logs, dependent: :delete_all
  has_many :absences, dependent: :delete_all

  after_initialize :set_leaves
  after_create :create_absence
  after_create :create_logs
  validates :name,
            presence:true,
            format: {
                with: /\A[a-zA-Zа-яА-Я.\s]+\z/,
                message: "only allows letters"
            }
  attr_accessor :leaves

  private
  def create_absence
    group.lessons.all.each do |lesson|
      Absence.create({student_id: self.id, lesson_id: lesson.id, amount: 0})
    end
  end

  def create_logs
    if group.logs.any?
      lessons_log = group.logs.select(:lesson_id).distinct
      lessons_log.each_with_index do |lesson_log|
        dates_log = group.logs.select(:date).where(lesson_id: lesson_log.lesson_id).distinct
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

  def set_leaves
    self.leaves = 0
    medical_certificates = self.medical_certificates.all
    logs = self.logs.where(flag: false)
    if logs.any? && medical_certificates.any?
      logs.each do |log|
        medical_certificates.each do |mc|
          self.leaves += 2 if log.date.between?(mc.from, mc.till)
        end
      end
    end
  end

end
