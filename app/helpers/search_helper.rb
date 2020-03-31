module SearchHelper
  def present_results(results)
    results[:results].map do |page|
      {
        link: {
          text: page.base_path,
          path: page_path(page)
        }
      }
    end
  end
end
