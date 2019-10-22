class Api::V1::UsersController < ApplicationController
	def user_profile
		user = User.find params[:id]
		if user.present?
			render json: { user: user, followers: user.followers, following: user.following, status: :success, message: "User found successfully" }
		else
			render json: { status: :success, message: "Couldn't find user" }
		end
	end

	def follow
		unless Follow.where(user_id: params[:user_id], follwer_id: current_user.id).present?
	    follow = Follow.create(user_id: params[:user_id], follwer_id: current_user.id)
	    if follow
	    	render json: { follow: follow, status: :success, message: "Followed successfully" }
	    else
	    	render json: { status: :success, message: "Failed to follow the user" }
	    end
		else
			render json: { status: :success, message: "Already following" }
		end
	end

	def unfollow
		follow = Follow.where(user_id: params[:user_id], follwer_id: current_user.id)
		unless follow.present?
	    if follow.first.destroy
	    	render json: { status: :success, message: "Unfollowed successfully" }
	    else
	    	render json: { status: :success, message: "Failed to unfollow the user" }		
	    end
		else
			render json: { status: :success, message: "You are not following this user" }		
		end
	end

	def followers_tweets
		user = User.find params[:user_id]
		following_ids = user.following.ids
		tweets = Tweet.where(user_id: following_ids)
		if tweets
    	render json: { tweets: tweets, status: :success, message: "Tweets found successfully" }
    else
    	render json: { tweets: [], status: :success, message: "To tweets found" }		
    end
	end
end
