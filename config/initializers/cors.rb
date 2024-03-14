Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.development?
      origins 'localhost:3000', '127.0.0.1:3000'
    elsif Rails.env.production?
      origins 'https://lyricraft-client.vercel.app'
    end
      resource '*',
        headers: :any,
        expose: ['Authorization', 'Accesstoken'],
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
  end
end
