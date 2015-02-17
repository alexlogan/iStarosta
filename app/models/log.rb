class Log < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :student
  belongs_to :group
  before_save :check_student_id
  after_create :set_absences, unless: :flag?
  after_update :update_absences,
               if: Proc.new { |log| log.flag_changed? }
  after_destroy :delete_absences, unless: :flag?
  validates :date, presence: true
  validates :lesson_id, presence: true, numericality: {only_integer: true}
  validates :student_id, presence: true, numericality: {only_integer: true}


  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |log|
        csv << log.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    SmarterCSV.process(file.path) do |array|
      if Lesson.exists?(array.first[:lesson_id])
        log = find_by_id(array.first[:id]) || new
        log.attributes = array.first
        log.save
      else
        break
      end
    end
  end


  private
  def check_student_id
    unless Student.exists?(self.student_id)
      false
    end
  end

  def set_absences
    row = student.absences.find_by(lesson_id: self.lesson_id)
    row.amount+=2
    row.save
  end

  def update_absences
    row = student.absences.find_by(lesson_id: self.lesson_id)
    if self.flag?
      row.amount-=2
      row.save
    else
      row.amount+=2
      row.save
    end
  end

  def delete_absences
    row = student.absences.find_by(lesson_id: self.lesson_id)
      row.amount-=2
      row.save
  end
end
