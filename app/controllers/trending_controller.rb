class TrendingController < ApplicationController
  include Searchable

  def index
    @top_pages = top_pages
    @most_frequent_exact_match_phrases = most_frequent_exact_match_phrases
    @most_frequent_generic_phrases = most_frequent_generic_phrases
    @trending_tags = trending_tags
    @top_user_groups = top_user_groups
  end

private

  def top_pages
    Page.top_pages(from_date_as_datetime, to_date_as_datetime).take(10)
  end

  def most_frequent_exact_match_phrases
    Phrase.most_frequent(from_date_as_datetime, to_date_as_datetime).take(10)
  end

  def most_frequent_generic_phrases
    GenericPhrase
      .most_frequent(from_date_as_datetime, to_date_as_datetime)
      .take(10)
  end

  def top_user_groups
    UserGroup.top_user_groups_by_date(from_date_as_datetime, to_date_as_datetime)
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
