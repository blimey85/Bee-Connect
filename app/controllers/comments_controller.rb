# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def index
    @comments = @post.comments.order('created_at asc')
    @postable = @post.postable

    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      unless @post.user.id == current_user.id
        Notification.find_or_initialize_by(recipient: @post.user, actor: current_user, action: 'commented', notifiable: @post).update!(read_at: nil)
      end
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    else
      flash[:alert] = 'Check the comment form, something went wrong.'
      render root_path
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])

    return nil unless @comment.user_id == current_user.id
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
