class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :following_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :followed_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followed_users, through: :followed_relationships, source: :follower

  #userが作成したItem
  has_many :ownerships , foreign_key: "user_id", dependent: :destroy
  has_many :items ,through: :ownerships
  
  #user_idとitem_idの構成は同じなので、OwnerShipの単一継承としてHaveモデル,Wantモデルを作成
  #ユーザーが欲しがっている商品
  has_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroy
  has_many :want_items, through: :wants, source: :item

  #ユーザーが持っている商品
  has_many :haves, class_name: "Have", foreign_key: "user_id", dependent: :destroy
  has_many :have_items, through: :haves, source: :item

  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_users.include?(other_user)
  end

  def have(item)
    if user.have_items.create(item_id: item.id)
      flash[:sucess] = 'have'
    else
      flash[:danger] = 'unhave'
    end
    redirect_to :back
  end

  def unhave(item)
    having_item = user.have_items.find_by(item_id: item.id)
    having_item.destroy if having_item
  end

  def have?(item)
    user.have_items.include?(item)
  end

  def want(item)
    if user.want_items.create(item_id: item.id)
      flash[:sucess] = 'want'
    else
      flash[:danger] = 'unwant'
    end
    redirect_to :back
  end

  def unwant(item)
    wanting_item = user.want_items.find_by(item_id: item.id)
    wanting_item.destroy if wanting_item
  end

  def want?(item)
    user.want_items.include?(item)
  end
end
