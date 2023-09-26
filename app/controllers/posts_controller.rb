class PostsController < ApplicationController
  def index
    user_id = params[:user_id]
    @user = User.includes(:posts).find(user_id) if user_id.present?
  end

  def show
    user_id = params[:user_id]
    post_id = params[:id]
    @user = User.find(user_id)
    @post = @user.posts.includes(:comments, :likes).find(post_id)
  end

  def new
    @current = current_user
  end

  def create
    new_post = current_user.posts.build(post_params)

    respond_to do |format|
      format.html do
        if new_post.save
          redirect_to user_post_path(new_post.user_id, new_post.id), notice: 'Post created successfully'
        else
          render :new, alert: 'An error occured. Please try again!'
        end
      end
    end
  end

  def follow
    @post = Post.find(params[:post_id])
    if Like.where(user_id: current_user.id, post_id: @post.id).present?
      Like.where(user_id: current_user.id, post_id: @post.id).destroy_all
      flash[:notice] = "Unfollowed"
    else
      @follow = Like.create(user_id: current_user.id, post_id: @post.id)
      flash[:notice] = "followed"
    end
    redirect_back(fallback_location: root_path)
  end

  def unfollow
    @post = Post.find(params[:post_id])
    @follow = @post.likes.where(user_id: current_user.id, post_id: @post.id).destroy_all
    flash[:notice] = "Un followed"
    redirect_back(fallback_location: root_path)
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
