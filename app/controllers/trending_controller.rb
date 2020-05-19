class TrendingController < ApplicationController
  attr_reader :filter_start_date, :filter_end_date

  def index
    @filter_start_date = Date.new(2020, 4, 1)
    @filter_end_date = Date.new(2020, 4, 7)

    @top_pages = top_pages
    @most_frequent_exact_match_phrases = most_frequent_exact_match_phrases
    @most_frequent_generic_phrases = most_frequent_generic_phrases
    @trending_tags = trending_tags
    @top_user_groups = top_user_groups
  end

private

  def top_pages
    Page.top_pages(filter_start_date, filter_end_date).take(10)
  end

  def most_frequent_exact_match_phrases
    Phrase.most_frequent(filter_start_date, filter_end_date).take(10)
  end

  def most_frequent_generic_phrases
    GenericPhrase
      .most_frequent(filter_start_date, filter_end_date)
      .take(10)
  end

  def top_user_groups
    UserGroup.top_user_groups_by_date(filter_start_date, filter_end_date)
  end

  def trending_tags
    [
      { text: "Food & deliveries", link: "#" },
      { text: "Vulnerable", link: "#" },
      { text: "Business loans", link: "#" },
      { text: "Isolation & quarantine", link: "#" },
      { text: "Lockdown & rules", link: "#" },
      { text: "Health/social care - staff", link: "#" },
      { text: "Travel & transport - UK", link: "#" },
      { text: "Livelihood - employee", link: "#" },
      { text: "Education & nursery", link: "#" },
      { text: "Profiteering", link: "#" },
    ]
  end
end
