class Micropost
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  field :content, type: String
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

end
