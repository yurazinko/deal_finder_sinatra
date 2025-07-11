# frozen_string_literal: true

require "spec_helper"

RSpec.describe Deal do
  let(:deal_data) do
    {
      "id" => "1",
      "title" => "Test Deal",
      "discount_price" => 50.0,
      "location" => {
        "lat" => 37.7749,
        "lng" => -122.4194
      }
    }
  end

  subject(:deal) { described_class.new(deal_data) }

  describe "#initialize and dynamic getters" do
    it "responds to defined keys as methods" do
      expect(deal.title).to eq("Test Deal")
      expect(deal.discount_price).to eq(50.0)
    end

    it "exposes raw attributes" do
      expect(deal.attributes).to eq(deal_data)
    end
  end

  describe "#to_h" do
    it "converts keys to symbols" do
      hash = deal.to_h
      expect(hash).to be_a(Hash)
      expect(hash.keys).to all(be_a(Symbol))
      expect(hash[:title]).to eq("Test Deal")
    end
  end

  describe "#distance_to" do
    context "when coordinates are valid" do
      it "returns a positive number" do
        user_lat = 37.8044
        user_lng = -122.2711
        expect(deal.distance_to(user_lat, user_lng)).to be > 0
      end
    end

    context "when coordinates are missing" do
      it "returns nil if location is nil" do
        deal_with_no_location = described_class.new({ "title" => "No location" })
        expect(deal_with_no_location.distance_to(1, 2)).to be_nil
      end

      it "returns nil if user_lat or user_lng is nil" do
        expect(deal.distance_to(nil, -122.3)).to be_nil
        expect(deal.distance_to(37.7, nil)).to be_nil
      end
    end
  end
end
