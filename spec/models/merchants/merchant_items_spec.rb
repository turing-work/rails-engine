require 'rails_helper'

RSpec.describe '.merchant_items(merchant_id)' do
  it 'returns all items for the given merchant' do
    merchant = Merchant.create!(id: 1, name: 'merchant1')
    10.times do
      create(:item, merchant_id: 1)
    end
    
    expect(Merchant.merchant_items(merchant.id).count).to eq(10)
    expect(Merchant.merchant_items(merchant.id).first.merchant_id).to eq(1)
    expect(Merchant.merchant_items(merchant.id).last.merchant_id).to eq(1)
  end
end