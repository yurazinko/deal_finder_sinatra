# frozen_string_literal: true

require "spec_helper"
RSpec.describe DealRepository do
  describe ".all" do
    let(:deals) { described_class.all }

    it "returns an array of Deal objects" do
      expect(deals).to all(be_a(Deal))
    end

    it "returns at least one deal with expected fields" do
      deal = deals.first
      expect(deal.title).to be_a(String)
      expect(deal.discount_price).to be_a(Numeric)
      expect(deal.location).to be_a(Hash)
      expect(deal.location[:lat]).to be_a(Float)
    end

    it "transforms camelCase keys to snake_case symbols" do
      deal = deals.find { |d| d.respond_to?(:discount_price) }
      expect(deal).to respond_to(:discount_price)
      expect(deal).to respond_to(:merchant_name)
      expect(deal).not_to respond_to(:discountPrice)
    end
  end
end
