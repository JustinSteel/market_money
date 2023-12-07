class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def not_found_response(exception)
    error_message = ErrorMessage.new(exception.message, 404)
    render json: ErrorSerializer.new(error_message).serialize_json, status: :not_found
  end
end
