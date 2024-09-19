module Api::ExceptionHandler
  extend ActiveSupport::Concern

  included do
    # rescue_fromは特定の種類の例外が発生したときに、それをキャッチして指定したメソッドに処理を渡す
    # 標準的なエラー（StandardError）が発生した場合、render_500メソッドを呼び出す
    rescue_from StandardError, with: :render_500
    # ActiveRecord::RecordNotFoundエラーが発生した場合、render_404メソッドを呼び出す
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    # CustomAuthenticationErrorが発生した場合、render_401メソッドを呼び出す
    rescue_from CustomAuthenticationError, with: :render_401
  end

  private

  # 400 Bad Request エラーを処理するメソッド
  def render_400(exception = nil, messages = nil)
    render_error(400, 'Bad Request', exception&.message, *messages)
  end

  # 401 Unauthorized エラーを処理するメソッド
  def render_401(exception = nil, messages = nil)
    render_error(401, 'Unauthorized', exception&.message, messages)
  end

  # 404 Record Not Found エラーを処理するメソッド
  def render_404(exception = nil, messages = nil)
    render_error(404, 'Record Not Found', exception&.message, *messages)
  end

  # 422 Unprocessable Entity エラーを処理するメソッド
  def render_422(exception = nil, messages = nil)
    render_error(422, 'Unprocessable Entity', exception&.message, *messages)
  end

  # 500 Internal Server Error エラーを処理するメソッド
  def render_500(exception = nil, messages = nil)
    render_error(500, 'Internal Server Error', exception&.message, *messages)
  end

  # 共通のエラーレスポンスを生成して返すためのメソッド
  # code: HTTPステータスコード
  # message: エラーメッセージ
  # error_messages: 追加のエラーメッセージ（オプション）
  def render_error(code, message, *error_messages)
    response = {
      message: message,
      errors: error_messages.compact # 空のエラーメッセージを取り除く
    }

    # JSON形式でエラーレスポンスを返す
    render json: response, status: code
  end
end
