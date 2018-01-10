class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content.max_length}
  validate  :picture_size

  private
  def picture_size
    if picture.size > Settings.attach.max_size.megabytes
      errors.add :picture, t("models.over_size_noti")
    end
  end
end
