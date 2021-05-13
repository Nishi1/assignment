=begin
  Namespace: Api::V1
  Class  : ApisController
  Extension: ApplicationController
  Summary  : Includes the common operations for API'S.
=end
class Api::V1::ApisController < ApplicationController
  def api_response(status_code, message, data)
    response = { 'status' => { 'code' => status_code, 'message' => message }, 'data' => data }
    return response
  end
end
