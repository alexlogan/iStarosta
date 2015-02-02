class Group < ActiveRecord::Base
  belongs_to :user
  has_many :students, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :logs, :through =>  :lessons, dependent: :delete_all

  validates :name, presence: true,
            uniqueness: true,
            format: {
              with: /\A[а-яА-Я\s]+/,
              message: "only allows letters"
            }
end
