# frozen_string_literal: true

require './uploader/profile_images_uploader'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3:db/development.db')

class User < ActiveRecord::Base
  extend CarrierWave::Mount
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  mount_uploader :image, ProfileImagesUploader
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :contributions
  validates :name, presence: true, length: { in: 4..15 }
  validates :screen_name, presence: true, length: { in: 1..50 }, uniqueness: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :role, presence: true
  has_secure_password
end

class Group < ActiveRecord::Base
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :contributions
  accepts_nested_attributes_for :user_groups
end

class Contribution < ActiveRecord::Base
  extend CarrierWave::Mount
  mount_uploader :image, ProfileImagesUploader
  belongs_to :user
  belongs_to :group
end

class UserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
end
