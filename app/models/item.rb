class Item < ActiveRecord::Base
  has_many :ownerships  , foreign_key: "item_id" , dependent: :destroy
  has_many :users , through: :ownerships
  has_many :wants, foreign_key: "item_id", dependent: :destroy
  has_many :want_users, through: :wants, source: :user
  has_many :haves, foreign_key: "item_id", dependent: :destroy
  has_many :have_users, through: :haves, source: :user
end
