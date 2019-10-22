class Api::V1::User::RegistrationsController < Devise::RegistrationsController
  def create
   ActiveRecord::Base.transaction do
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
  

end






