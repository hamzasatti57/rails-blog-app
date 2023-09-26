class LikesController < ApplicationController
  def create
    debugger
    @post = Post.find(params[:post_id])
    @follow = @post.likes.create(user_id: current_user.id, post_id: @post.id)
    respond_to do |format|
      format.html do
        if @follow.save
          redirect_to user_post_path(@post.user.id, @post.id), notice: 'followed 👍'
        else
          redirect_to user_post_path(@post.user.id, @post.id), alert: 'An error occured, please try again!'
        end
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @follow = @post.likes.find_by(params[:id]))

    respond_to do |format|
      format.html do
        if @follow.destroy
          redirect_to user_post_path(@post.user.id, @post.id), notice: 'Un followed 👍'
        else
          redirect_to user_post_path(@post.user.id, @post.id), alert: 'An error occured, please try again!'
        end
      end
    end
  end
end
