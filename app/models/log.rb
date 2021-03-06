class Log < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :student
  belongs_to :group
  before_save :check_student_id
  validates :date, presence: true
  validates :block, presence: true, numericality: {
                       only_integer: true,
                       greater_than_or_equal_to:  1,
                       less_than_or_equal_to: 2
                     }
  validates :transaction_id, presence: true, numericality: {
                    only_integer: true,
                  }
  validates :lesson_id, presence: true, numericality: {only_integer: true}
  validates :student_id, presence: true, numericality: {only_integer: true}


  def self.to_csv(options = {})
    column_names = %w(id student_id lesson_id flag date block transaction_id)
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |log|
        csv << log.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(user, file)
    Log.transaction do
      SmarterCSV.process(file.path) do |array|
        if user.group.lessons.exists?(array.first[:lesson_id]) and user.group.students.exists?(array.first[:student_id])
          lesson = Lesson.find_by_id(array.first[:lesson_id])
          log = find_by_id(array.first[:id]) || lesson.logs.build
          log.student_id = array.first[:student_id]
          log.flag = array.first[:flag]
          log.date = array.first[:date]
          log.block = array.first[:block]
          log.transaction_id = array.first[:transaction_id]
          log.save
        else
          raise IOError
        end
      end
    end

  end


  private

  def check_student_id
    unless Student.exists?(self.student_id)
      false
    end
  end

end
