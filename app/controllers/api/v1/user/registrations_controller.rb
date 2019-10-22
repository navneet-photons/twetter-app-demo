class Api::V1::User::RegistrationsController < Devise::RegistrationsController
  def create
   ActiveRecord::Base.transaction do
    debugger
     build_resource(sign_up_params)
       resource.save
       yield resource if block_given?
     unless resource.persisted?
       clean_up_passwords resource
       set_minimum_password_length
       return render json:{errors: resource.errors.as_json}
     end
     if resource.active_for_authentication?
       sign_up(resource_name, resource)
     else
       expire_data_after_sign_in!
     end
     @user = resource
      render json: { user: resource, status: :success, message: "User created successfully" }
    end
  end
  # def create
  #   unless User.where(email: params[:user][:email]).exists?
  #     if params[:user][:password] == params[:user][:password_confirmation]
  #       @user = User.new({email: params[:user][:email], password: params[:user][:password],password_confirmation: params[:user][:password_confirmation]})
  #       if @user.save   
  #         render json: { user: resource, status: :success, message: "User created successfully" }
  #       else
  #         render json: { user: resource, status: :success, message: "Failed to create user" }
  #       end
  #     end 
  #   else
  #     render json: {  status: :success, message: "User Already Exists" }
  #   end      
  # end 

end






