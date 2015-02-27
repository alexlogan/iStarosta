class Group < ActiveRecord::Base
  belongs_to :user
  has_many :students, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :logs, :through =>  :lessons

  validates :name, presence: true,
            uniqueness: true,
            format: {
              with: /\A[A-ZА-Я0-9]+\z/,
              message: "Только буквы и цифры без пробелов"
            }
  after_initialize :set_attendance
  after_initialize :set_total_pairs
  attr_accessor :attendance, :total_pairs

  private
  def set_attendance
    if self.logs.any?
      self.attendance = (self.logs.where(flag: true).count.to_f/self.logs.count.to_f*100).round
    end
  end

  def set_total_pairs
    self.total_pairs = self.logs.group(:lesson_id, :date).count(:id).length
  end
end
