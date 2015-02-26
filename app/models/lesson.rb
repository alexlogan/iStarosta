class Lesson < ActiveRecord::Base
  belongs_to :group
  has_many :logs, dependent: :delete_all

  validates :name, presence:true
  after_create :create_absence
  before_save :add_type_to_name,
              if: Proc.new{|lesson| lesson.kind_changed?}

  enum kind: [:Лекция, :Практика]

  private
  def create_absence
    group.students.all.each do |student|
      self.absence.create({student_id: student.id, amount: 0})
    end
  end

  def add_type_to_name
    case self.kind
      when 'Лекция'
        if self.name.scan("(пр)").present?
          self.name.gsub!("(пр)", "(лек)")
        else
          self.name=name+" (лек)"
        end
      when 'Практика'
        if self.name.scan("(лек)").present?
          self.name.gsub!("(лек)", "(пр)")
        else
          self.name=name+" (пр)"
        end
      else
        self.name=name+" (!!!)"
    end
  end
end