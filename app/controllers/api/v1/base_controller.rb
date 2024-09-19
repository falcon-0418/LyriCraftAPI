class Api::V1::BaseController < ApplicationController
  include Api::ExceptionHandler
  # トークンベースの認証をサポートするために、Token::ControllerMethodsをインクルード
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  protected

  # トークンを使用してユーザーを認証するメソッド
  # 有効なトークンが存在しない場合は、リクエストを拒否
  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      # トークンに対応するユーザーをデータベースから取得し、@_current_userに保存
      @_current_user ||= ApiKey.active.find_by(access_token: token)&.user
    end
  end

  # 現在の認証済みユーザーを返すメソッド
  def current_user
    @_current_user
  end

  # ユーザーに新しいアクセストークンを発行し、それをHTTPレスポンスのヘッダーに格納するメソッド
  def set_access_token!(user)
    api_key = user.activate_api_key!
    response.headers['Accesstoken'] = api_key.access_token
  end

  private

  # RailsのAPIモードで必要になる場合がある一時的な解決策
  # Railsの内部ロジックがこのメソッドを呼び出すことを期待している場合、空メソッドとして定義しておくことでエラーを回避する
  # 詳しくは以下のリンクを参照
  # https://qiita.com/okaeri_ryoma/items/0d01469f2265e5d51af1
  def form_authenticity_token; end
end
