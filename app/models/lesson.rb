class Lesson < ActiveRecord::Base
  belongs_to :group
  has_many :logs, dependent: :delete_all
  has_many :absence, dependent: :delete_all

  after_save :create_absence
  validates :name,
            presence:true,
            format: {
              with: /\A[a-zA-Zа-яА-Я0-9.\s]+\z/,
              message: "only allows letters, numbers and \".\""
            }

  private
  def create_absence
    group.students.all.each do |student|
      Absence.create({student_id: student.id, lesson_id: self.id, amount: 0})
    end
  end
end