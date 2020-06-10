class UsersController < ApplicationController
  before_action :authorize_request, except: [:create]

  def index
    @users = User.all
    
    render json: @users.as_json(except: %i[created_at updated_at]), status: :ok
  end

  def show
    @user = User.where(id: params[:id]).first

    if @user
      render json: @user.as_json(except: %i[created_at updated_at]), status: :ok
    else
      render json: {status: 'ERROR', message: 'The user does not exist'},status: :unprocessable_entity
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: {status: 'SUCCES', message: 'Created user', data:@user.as_json(except: %i[created_at updated_at photo_path])}, status: :created
    else
      render json: {status: 'ERROR', message: 'User not created', data:@user.errors},status: :unprocessable_entity
    end
  end

  def destroy 
    @user = User.where(id: params[:id]).first

    if @user
      if @user.destroy
        render json: {status: 'SUCCES', message: 'The user has been deleted'}, status: :ok
      else
        render json: {status: 'ERROR', message: 'The user could not be removed'},status: :unprocessable_entity
      end
    else
      render json: {status: 'ERROR', message: 'The user does not exist'},status: :unprocessable_entity
    end
  end

  private 

  def user_params
    params.permit(:email, :password, :password_confirmation, :full_name)
  end
end