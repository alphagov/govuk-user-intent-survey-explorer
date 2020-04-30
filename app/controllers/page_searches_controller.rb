class PageSearchesController < ApplicationController
  def show
    @results = results
  end

private

  def results
    response = Page.search params[:q].to_s.gsub("/", "")
    {
      total: response.records.uniq(&:base_path).count,
      results: response.records.uniq(&:base_path),
    }
  end
end
