module PhraseUsageHelper
  def highlighted_survey_answer_html(survey_answer, phrase)
    survey_answer.gsub(/(#{phrase})/i){ |match| "<span class='phrase-highlight'>#{match}</span>" }.html_safe
  end

  def phrase_usage_navigation_links
    links = {}

    if @presenter.pagination.page > 1
      links = links.merge(
        previous_page: {
          url: path_to_previous_page(@presenter.survey_answers_containing_phrase),
          title: "Previous page",
          label: "#{@presenter.pagination.page - 1} of #{@presenter.pagination.total_pages}"
        }
      )
    end

    if @presenter.pagination.page < @presenter.pagination.total_pages
      links = links.merge(
        next_page: {
          url: path_to_next_page(@presenter.survey_answers_containing_phrase),
          title: "Next page",
          label: "#{@presenter.pagination.page + 1} of #{@presenter.pagination.total_pages}"
        }
      )
    end

    links
  end
end
