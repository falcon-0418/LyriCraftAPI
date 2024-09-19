Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.development?
      origins 'localhost:8000', '127.0.0.1:8000'
    elsif Rails.env.production?
      origins 'https://lyricraft-client.vercel.app', 'https://www.lyricraft-app.com'
    end
      resource '*',
        headers: :any,
        expose: ['Authorization', 'Accesstoken'],
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
  end
end
