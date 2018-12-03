# This will guess the User class
FactoryBot.define do
  factory :thermostat do
    household_token { Faker::Lorem.characters(14) }
    location { Faker::Address.full_address }
    uuid { SecureRandom.uuid }
  end
end
