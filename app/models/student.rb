class Student < ActiveRecord::Base
  belongs_to :group
  has_many :medical_certificates, dependent: :destroy
  has_many :logs, dependent: :delete_all

  after_initialize :set_leaves, unless: Proc.new{ new_record? }
  after_initialize :set_absences, unless: Proc.new{ new_record? }
  after_create :create_logs, if: Proc.new { group.logs.any? }
  validates :name,
            presence:true,
            format: {
                with: /\A[a-zA-Zа-яА-Я.\s]+\z/,
                message: "только буквы"
            }
  attr_accessor :leaves, :absences

  private

  def create_logs
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

  def set_absences
    self.absences = Hash.new
    lessons = self.group.lessons.where(
      semester: self.group.setting.current_semester
    ).order(:name)
    lessons.each do |lesson|
      self.absences[lesson.name.to_sym] = {
        first: lesson.logs.where(block: 1, flag: false, student_id: self.id).count,
        second: lesson.logs.where(block: 2, flag: false, student_id: self.id).count
      }
    end
  end

  def set_leaves
    self.leaves = {:first => 0, :second => 0}
    medical_certificates = self.medical_certificates.where(semester: self.group.setting.current_semester)
    logs = self.logs.where(block: self.group.setting.current_block, flag: false)
    if logs.any? && medical_certificates.any?
      logs.each do |log|
        medical_certificates.each do |mc|
          if log.date.between?(mc.from, mc.till)
            log.block==1 ? self.leaves[:first] += 1 : self.leaves[:second] += 1
          end
        end
      end
    end
  end

end
