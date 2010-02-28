class Comment < ActiveRecord::Base
  has_one :approval
  belongs_to :post
end
