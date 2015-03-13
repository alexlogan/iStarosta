class Group < ActiveRecord::Base
  belongs_to :user
  has_one :setting, dependent: :delete
  has_many :students, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :logs, :through =>  :lessons

  validates :name, presence: true,
            uniqueness: true,
            format: {
              with: /\A[A-ZА-Я0-9]+\z/,
              message: "Только буквы и цифры без пробелов"
            }
  after_create :create_setting
  after_initialize :update_current_block_setting,
                   if: Proc.new{
                     setting.try(:threshold_date).present? &&
                       setting.threshold_date <= Date.today &&
                       setting.current_block == 1 }
  after_initialize :set_attendance, unless: Proc.new{ new_record? }
  after_initialize :set_total_pairs, unless: Proc.new{ new_record? }
  attr_accessor :attendance, :total_pairs

  def delete_group_logs
    lessons.map { |lesson| lesson.logs.delete_all}
  end

  private
  def create_setting
    build_setting if setting.nil?
    self.save
  end

  def update_current_block_setting
    self.setting.current_block = 2
    self.setting.save
  end

  def set_attendance
    if self.logs.any?
      self.attendance = (self.logs.where(
        lessons: {semester: self.setting.current_semester},
        flag: true
      ).count.to_f/self.logs.count.to_f*100).round
    end
  end

  def set_total_pairs
    self.total_pairs = self.logs.where(
      lessons: {semester: self.setting.current_semester}
    ).group(:lesson_id, :date).count(:id).length
  end
end
