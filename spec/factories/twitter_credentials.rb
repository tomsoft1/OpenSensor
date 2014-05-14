# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :twitter_credential do
    screen_name ""
    token ""
    token_secret ""
  end
end
