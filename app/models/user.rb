class User < ActiveRecord::Base
  has_one :group, :autosave => true, dependent: :destroy
  has_one :setting, :through => :group, dependent: :destroy
  has_many :students, :through => :group
  has_many :lessons, :through => :group
  accepts_nested_attributes_for :group

  before_create :add_admin_role, unless: Proc.new { User.exists? }

  validates :name, presence: true,
            format: {
              with: /\A[а-яА-Яa-zA-Z\s]+\z/,
              message: "only allows letters"
            }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %i[admin]
  # arr.reject {|e| e == 5}

  def with_group
    build_group if group.nil?
    self
  end

  def admin?
    self.role == 'admin'
  end

  private
  def add_admin_role
    self.role = 'admin'
  end

end
