module Api::ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from CustomAuthenticationError, with: :render_401
  end

  private

  def render_400(exception = nil, messages = nil)
    render_error(400, 'Bad Request', exception&.message, *messages)
  end

  def render_401(exception = nil, messages = nil)
    render_error(401, 'Unauthorized', exception&.message, messages)
  end

  def render_404(exception = nil, messages = nil)
    render_error(404, 'Record Not Found', exception&.message, *messages)
  end

  def render_422(exception = nil, messages = nil)
    render_error(422, 'unprocessable_entity', exception&.message, *messages)
  end

  def render_500(exception = nil, messages = nil)
    render_error(500, 'Internal Server Error', exception&.message, *messages)
  end

  def render_error(code, message, *error_messages)
    response = {
      message: message,
      errors: error_messages.compact
    }

    render json: response, status: code
  end
end
