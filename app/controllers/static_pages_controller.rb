class StaticPagesController < ApplicationController
  def home
     if logged_in?
      @micropost  = current_user.microposts.build
      following_ids = "SELECT followed_id FROM relationships
        WHERE  follower_id = #{current_user.id}"
      @feed_items = Micropost.where("user_id IN (#{following_ids})
        OR user_id = #{current_user.id}")
        .paginate page: params[:page], per_page: Settings.paginate.num_per_page
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
