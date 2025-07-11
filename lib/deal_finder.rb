# frozen_string_literal: true

class DealFinder
  def initialize(params)
    @min_price = params["min_price"]&.to_f || 0
    @max_price = params["max_price"]&.to_f || Float::INFINITY
    @category  = params["category"]
    @lat       = params["lat"]&.to_f
    @lng       = params["lng"]&.to_f
    @tags      = Array(params["tags"])
  end

  def call
    filtered = DealRepository.all.select { |deal| match?(deal) }

    scorer = DealScorer.new(user_lat: @lat, user_lng: @lng)
    filtered
      .map { |deal| [deal, scorer.score(deal)] }
      .sort_by { |_, score| -score }
      .map { |deal, score| deal.to_h.merge(score: score.round(3)) }
  end

  private

  def match?(deal)
    deal.discount_price.between?(@min_price, @max_price) &&
      (@category.nil? || deal.category.to_s.downcase == @category.downcase) &&
      (@tags.empty? || (@tags - deal.tags).empty?)
  end
end
