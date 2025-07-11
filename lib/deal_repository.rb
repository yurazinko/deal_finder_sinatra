# frozen_string_literal: true

require_relative "deal"
require "active_support/core_ext/hash/keys"
require "active_support/inflector"

class DealRepository
  def self.all
    path = File.expand_path("../deals.json", __dir__)
    raw_data = JSON.parse(File.read(path))

    raw_data.map do |item|
      Deal.new(
        item.deep_transform_keys { |key| key.underscore.to_sym }
      )
    end
  end
end
