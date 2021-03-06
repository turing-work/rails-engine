require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  before :each do
    FactoryBot.reload
  end

  describe '.all_objects(page_number = 1, per_page = 20)' do
    it 'returns all objects, 20 at a time default' do
      25.times do
        create(:item)
      end
      
      expect(Merchant.all_objects(1).count).to eq(20)
      expect(Merchant.all_objects(1).first.name).to eq('merchant1')
      expect(Merchant.all_objects(1).last.name).to eq('merchant20')

      expect(Merchant.all_objects(2).count).to eq(5)
      expect(Merchant.all_objects(2).first.name).to eq('merchant21')
      expect(Merchant.all_objects(2).last.name).to eq('merchant25')

      expect(Item.all_objects(1).count).to eq(20)
      expect(Item.all_objects(1).first.name).to eq('item1')
      expect(Item.all_objects(1).last.name).to eq('item20')

      expect(Item.all_objects(2).count).to eq(5)
      expect(Item.all_objects(2).first.name).to eq('item21')
      expect(Item.all_objects(2).last.name).to eq('item25')
    end

    it 'returns first page if no page is specified' do
      25.times do
        create(:item)
      end
      
      expect(Merchant.all_objects.count).to eq(20)
      expect(Merchant.all_objects.first.name).to eq('merchant1')
      expect(Merchant.all_objects.last.name).to eq('merchant20')

      expect(Item.all_objects.count).to eq(20)
      expect(Item.all_objects.first.name).to eq('item1')
      expect(Item.all_objects.last.name).to eq('item20')
    end
    
    it 'returns the first page if the page number is less than 1' do
      25.times do
        create(:item)
      end

      expect(Merchant.all_objects(-1).count).to eq(20)
      expect(Merchant.all_objects.first.name).to eq('merchant1')
      expect(Merchant.all_objects.last.name).to eq('merchant20')

      expect(Item.all_objects(-1).count).to eq(20)
      expect(Item.all_objects.first.name).to eq('item1')
      expect(Item.all_objects.last.name).to eq('item20')
    end

    it 'can specify the number of objects per page' do
      25.times do
        create(:item)
      end

      expect(Merchant.all_objects(page_number = 1, per_page = 25).count).to eq(25)
      expect(Merchant.all_objects(page_number = 1, per_page = 25).first.name).to eq('merchant1')
      expect(Merchant.all_objects(page_number = 1, per_page = 25).last.name).to eq('merchant25')

      expect(Item.all_objects(page_number = 1, per_page = 25).count).to eq(25)
      expect(Item.all_objects(page_number = 1, per_page = 25).first.name).to eq('item1')
      expect(Item.all_objects(page_number = 1, per_page = 25).last.name).to eq('item25')
    end
  end
end