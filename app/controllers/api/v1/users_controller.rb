=begin
  Namespace: Api::V1
  Class  : UsersController
  Extension: Api::V1::ApisController
  Summary  : Includes the operations to manage employees.
=end
class Api::V1::UsersController < Api::V1::ApisController
  skip_before_action :verify_authenticity_token

  #GET /users
  def index
    users = User.order('salary desc').limit(USER_RECORD_PER_PAGE)
    render json: api_response(SUCCESS_CODE, 'Users data received', users)
  end

  #GET /users_hierarchy/:hierarchy_point
  def hierarchy
    unless params[:hierarchy_point].present?
      render json: api_response(BAD_REQUEST_CODE, 'Required params are missing', []) and return
    end
    user_types_count = User.user_types.length
    user_hierarchy   = []
    User.user_types.each do |k, v|
      if v >= params[:hierarchy_point].to_i && v <= User.user_types.length - 1
        user_hierarchy << k.titlecase
      end
    end
    render json: api_response(SUCCESS_CODE, 'Hierarchy data received', user_hierarchy.reverse)
  end

  #POST users
  def create
    unless params.present?
      render json: api_response(BAD_REQUEST_CODE, 'Required params are missing', []) and return
    end
    user = User.new(user_params)
    if user.save
      response = api_response(SUCCESS_CODE, 'User saved successfully', user)
    else
      response = api_response(BAD_REQUEST_CODE, user.errors, [])
    end
    render json: response
  end

  #DELETE users/:id
  #Assuming we are soft deleting user and managing status flag for that
  def destroy
    unless params[:id].present?
      render json: api_response(BAD_REQUEST_CODE, 'Required params are missing', []) and return
    end
    user = User.unscoped.find_by_id(params[:id])
    if user.present?
      if user.status == true
        if user.soft_delete
          if user.user_type_id == User.user_types['manager']
            #Fetching manager first reporter employee
            new_reporter_id = user.user_reporters.present? ? user.user_reporters.first.reporter_id : ''
            if new_reporter_id.present?
              UserReporter.where(:reporter_id => user.id).update_all({ :reporter_id => new_reporter_id })
            end
          end
          response = api_response(SUCCESS_CODE, 'User deleted successfully', [])
        else
          response = api_response(INTERNAL_SERVER_CODE, 'An intyernal error occurred', [])
        end
      else
        response = api_response(SUCCESS_CODE, 'User already deleted', [])
      end
    else
      response = api_response(NOT_FOUND_CODE, 'User not found', [])
    end
    render json: response
  end

  private

  #The user_params method returns a copy of the model object, returning only the permitted keys and values and when creating a new record only the permitted attributes are passed into the model.
  def user_params
    params.require(:user).permit(:user_type_id, :name, :email, :salary, :status, user_reporters_attributes: [:id, :user_id, :reporter_id])
  end
end