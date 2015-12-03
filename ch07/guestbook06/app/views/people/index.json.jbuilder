json.array!(@people) do |person|
  json.extract! person, :id, :name, :secret, :country, :email, :description, :can_send_email, :graduation_year, :body_temperature, :price, :birthday, :favorite_time
  json.url person_url(person, format: :json)
end
