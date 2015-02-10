class Group < ActiveRecord::Base
  belongs_to :user
  has_many :students, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :logs, :through =>  :lessons

  validates :name, presence: true,
            uniqueness: true,
            format: {
              with: /\A[A-ZА-Я0-9]+\z/,
              message: "only allows letters and numbers, not whitespaces"
            }
end
