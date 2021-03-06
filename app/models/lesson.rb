class Lesson < ActiveRecord::Base
  belongs_to :group
  has_many :logs, dependent: :delete_all

  validates :name, presence: true
  validates :semester, presence: true, numericality: {
                       only_integer: true,
                       greater_than_or_equal_to:  1,
                       less_than_or_equal_to: 12 }
  validates :kind, presence: true
  before_save :add_type_to_name,
              if: Proc.new{ kind_changed? }

  after_initialize :set_attendance

  attr_accessor :attendance
  enum kind: [:Лекция, :Практика]


  def self.to_csv(options = {})
    column_names = %w(id name kind semester)
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |lesson|
        csv << lesson.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(user, file)
    SmarterCSV.process(file.path) do |array|
      lesson = find_by_id(array.first[:id]) || user.group.lessons.build
      if user.can? :manage, lesson
        lesson.id = array.first[:id] if lesson.new_record?
        lesson.name = array.first[:name]
        lesson.kind = array.first[:kind]
        lesson.semester = array.first[:semester]
        lesson.save
      else
        raise IOError
      end
    end
  end

  private
  def add_type_to_name
    case self.kind
      when 'Лекция'
        if self.name.scan('(пр)').present?
          self.name.gsub!('(пр)', '(лек)')
        elsif self.name.scan('(лек)').blank?
          self.name=name+' (лек)'
        end
      when 'Практика'
        if self.name.scan('(лек)').present?
          self.name.gsub!('(лек)', '(пр)')
        elsif self.name.scan('(пр)').blank?
          self.name=name+' (пр)'
        end
      else
        self.name=name+' (!!!)'
    end
  end

  def set_attendance
    if self.logs.any?
      self.attendance = (self.logs.where(flag: true).count.to_f/self.logs.count.to_f*100).round
    end
  end

end