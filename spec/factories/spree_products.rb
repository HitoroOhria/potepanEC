FactoryBot.define do
  factory :spree_product, class: Spree::Product do
    name        { 'test_product' }
    price       { 500 }
    description { 'this is test product' }
    shipping_category_id  { 1 }
    sequence(:slug) { |n| "testproduct_slug#{n}" }
  end
end
