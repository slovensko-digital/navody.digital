# Authentication allowing only admin to view the que status
Que::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [Rails.application.config_for(:app).dig(:admin, :username),
                       Rails.application.config_for(:app).dig(:admin, :password)]
end
