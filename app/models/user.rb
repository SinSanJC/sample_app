class User
	include Mongoid::Document
	include Mongoid::Timestamps
	include ActiveModel::SecurePassword

	attr_accessor :remember_token, :activation_token

	before_save   :downcase_email
	before_create :create_activation_digest

	has_many :microposts, dependent: :destroy
	has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", inverse_of: :follower, dependent: :destroy
	has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", inverse_of: :followed, dependent: :destroy


	field :name, type: String
	field :email, type: String
	field :password_digest, type: String
	field :remember_digest, type: String
	field :admin, type: Boolean, default: false
	field :activation_digest, type: String
	field :activated, type: Boolean, default: false
	field :activated_at, type: DateTime

	has_secure_password
	
	validates :name,  presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }


	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end	

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		if digest.nil?
			false 
		else
			BCrypt::Password.new(digest).is_password?(token)
		end
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	def downcase_email
		self.email = email.downcase
	end

	def create_activation_digest
		self.activation_token  = User.new_token
		self.activation_digest = User.digest(activation_token)
	end

	def activate
		update_attribute(:activated, true)
		update_attribute(:activated_at, Time.zone.now)
	end

	# Sends activation email.
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end	

	def feed
		Micropost.from_users_followed_by(self)
	end

	def follow(other_user)
		active_relationships.create(followed_id: other_user._id)
	end

	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user._id).delete
	end

	def following
		Relationship.where(follower_id: _id).pluck(:followed)
	end
	
	def followers
		Relationship.where(followed_id: _id).pluck(:follower)
	end

	def following?(other_user)
		return true if active_relationships.find_by(followed_id: other_user._id)
	end


end
