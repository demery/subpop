class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # local attribute for account restoration
  attr_accessor :restore_account

  before_save :undelete,  if: :restore_account?

  validates :username, presence: true, uniqueness: true

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  # restore the account
  def undelete
    self.deleted_at = nil
  end

  def restore_account?
    @restore_account.present?
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

end
