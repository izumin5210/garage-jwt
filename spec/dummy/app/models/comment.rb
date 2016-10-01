class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  alias :commenter, :user

  def post_owner
    post.user
  end

  include Garage::Representer

  property :id
  property :body
  property :commenter
  property :post_owner, selectable: true
end
