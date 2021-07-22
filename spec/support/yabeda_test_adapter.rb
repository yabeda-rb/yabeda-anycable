# frozen_string_literal: true

require "yabeda/base_adapter"

class YabedaTestAdapter < Yabeda::BaseAdapter
  def register!(*); end

  def perform_counter_increment!(*); end

  def perform_gauge_set!(*); end

  def perform_histogram_measure!(*); end
end
