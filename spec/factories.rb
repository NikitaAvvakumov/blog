FactoryGirl.define do
  factory :user do
    name 'Nik'
    email 'nik@quoth.com'
    password 'something'
    password_confirmation 'something'
    bio 'A breathtaking tale of adventure.'
  end

  factory :post do
    title 'A brand new post'
    body 'Lorem ipsum dolor sit amet'
    user
  end
end