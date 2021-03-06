require 'rails_helper'
RSpec.describe 'Merchants with most items sold' do
  it 'can return the top merchant' do
    customer = Customer.create!(first_name: "Cust", last_name: "Tomer")
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    invoice1 = create(:invoice, merchant_id: merchant1.id, customer_id: customer.id)
    invoice2 = create(:invoice, merchant_id: merchant2.id, customer_id: customer.id)
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant2)

    transaction1 = create(:transaction, invoice: invoice1, result: 'success')

    transaction2 = create(:transaction, invoice: invoice2, result: 'success')

    2.times do
      create(:invoice_item, item: item1, invoice: invoice1)
    end

    create(:invoice_item, item: item2, invoice: invoice2)

    get '/api/v1/merchants/most_items?quantity=1'
    
    expect(response).to be_successful
    expect(response.status).to eq(200)
    
    merchants= JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to be_a Hash
    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_an Array
    expect(merchants[:data].count).to eq(1)
    expect(merchants[:data].first).to be_a Hash
    expect(merchants[:data].first.keys).to eq([:id, :type, :attributes])
    expect(merchants[:data].first[:id]).to be_a String
    expect(merchants[:data].first[:type]).to be_a String
    expect(merchants[:data].first[:attributes]).to be_a Hash
    expect(merchants[:data].first[:attributes].keys).to eq([:name, :count])
    expect(merchants[:data].first[:attributes][:name]).to be_a String
    expect(merchants[:data].first[:attributes][:count]).to be_a Integer
  end

  it 'can get multiple merchants' do
    customer = Customer.create!(first_name: "Cust", last_name: "Tomer")
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)

    invoice1 = create(:invoice, merchant_id: merchant1.id, customer_id: customer.id)
    invoice2 = create(:invoice, merchant_id: merchant2.id, customer_id: customer.id)
    invoice3 = create(:invoice, merchant_id: merchant3.id, customer_id: customer.id)

    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant2)
    item3 = create(:item, merchant: merchant3)

    transaction1 = create(:transaction, invoice: invoice1, result: 'success')
    transaction2 = create(:transaction, invoice: invoice2, result: 'success')
    transaction3 = create(:transaction, invoice: invoice3, result: 'success')

    2.times do
      create(:invoice_item, item: item1, invoice: invoice1)
    end

    4.times do
      create(:invoice_item, item: item3, invoice: invoice3)
    end

    create(:invoice_item, item: item2, invoice: invoice2)

    get '/api/v1/merchants/most_items?quantity=3'
    
    expect(response).to be_successful
    expect(response.status).to eq(200)
    
    merchants= JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to be_a Hash
    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_an Array
    expect(merchants[:data].count).to eq(3)
    expect(merchants[:data].first).to be_a Hash
    expect(merchants[:data].first.keys).to eq([:id, :type, :attributes])
    expect(merchants[:data].first[:id]).to be_a String
    expect(merchants[:data].first[:type]).to be_a String
    expect(merchants[:data].first[:attributes]).to be_a Hash
    expect(merchants[:data].first[:attributes].keys).to eq([:name, :count])
    expect(merchants[:data].first[:attributes][:name]).to be_a String
    expect(merchants[:data].first[:attributes][:count]).to be_a Integer
  end

  it 'gets all merchants if quantity is larger than number of merchants' do
    customer = Customer.create!(first_name: "Cust", last_name: "Tomer")
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    invoice1 = create(:invoice, merchant_id: merchant1.id, customer_id: customer.id)
    invoice2 = create(:invoice, merchant_id: merchant2.id, customer_id: customer.id)
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant2)

    transaction1 = create(:transaction, invoice: invoice1, result: 'success')

    transaction2 = create(:transaction, invoice: invoice2, result: 'success')

    2.times do
      create(:invoice_item, item: item1, invoice: invoice1)
    end

    create(:invoice_item, item: item2, invoice: invoice2)

    get '/api/v1/merchants/most_items?quantity=10'
    
    expect(response).to be_successful
    expect(response.status).to eq(200)
    
    merchants= JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to be_a Hash
    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_an Array
    expect(merchants[:data].count).to eq(2)
    expect(merchants[:data].first).to be_a Hash
    expect(merchants[:data].first.keys).to eq([:id, :type, :attributes])
    expect(merchants[:data].first[:id]).to be_a String
    expect(merchants[:data].first[:type]).to be_a String
    expect(merchants[:data].first[:attributes]).to be_a Hash
    expect(merchants[:data].first[:attributes].keys).to eq([:name, :count])
    expect(merchants[:data].first[:attributes][:name]).to be_a String
    expect(merchants[:data].first[:attributes][:count]).to be_a Integer
  end

  describe 'sad path' do
    it 'returns 400 if quantity is a string' do
      get '/api/v1/merchants/most_items?quantity=blah'
      
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end

    it 'returns 400 if quantity is blank' do
      get '/api/v1/merchants/most_items?quantity='
    
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
    end
  end
end