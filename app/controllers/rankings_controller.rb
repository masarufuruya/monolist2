class RankingsController < ApplicationController
  #haveの上位10個
  def have
    have_ranking_counts = Have.group(:item_id).limit(10).order('count_item_id desc').count(:item_id) 
    @have_ranking_items = []
    have_ranking_counts.each do |item_id, count|
      item = Item.find_by(id: item_id)
      @have_ranking_items << item unless item.nil?
    end
  end
  
  #wantの上位10個
  def want
    want_ranking_counts = Want.group(:item_id).limit(10).order('count_item_id desc').count(:item_id) 
    @want_ranking_items = []
    want_ranking_counts.each do |item_id, count|
      item = Item.find_by(id: item_id)
      @want_ranking_items << item unless item.nil?
    end
  end
end