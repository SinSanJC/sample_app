class Micropost
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  field :content, type: String
  field :picture, type: String

  mount_uploader :picture, PictureUploader
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

	def picture_size
		if picture.size > 3.megabytes
			errors.add(:picture, "should be less than 3MB")
		end
	end 

	def self.from_users_followed_by(user)
		following_ids = user.following
		any_of({user_id: user._id}, {:user_id.in => following_ids})
	end

end
