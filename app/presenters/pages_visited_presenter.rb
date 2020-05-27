class PagesVisitedPresenter
  attr_reader :pagination, :search_params, :items, :phrase
  delegate :page, :total_pages, to: :pagination
  include ::TableSortable

  def initialize(phrase, items, search_options)
    @phrase = phrase
    @search_options = search_options
    @pagination = PaginationPresenter.new(page: search_options[:page], total_items: items.count)
    @items = pagination.paginate(items)
  end

  def head
    # TODO: Refactor this to use more of table sortable
    column_map = {
      "base_path" => {
        text: "Page title",
        href: "#{pages_visited_path(phrase)}?sort_key=base_path&sort_dir=asc",
      },
      "unique_visitors" => {
        text: "Number of unique visitors",
        format: "numeric",
        href: "#{pages_visited_path(phrase)}?sort_key=unique_visitors&sort_dir=asc",
      },
    }

    mapping = {
      asc: "ascending",
      desc: "descending",
    }

    if sort_key.present?
      dir = sort_dir == :asc ? :desc : :asc
      column_map[sort_key].merge!(
        {
          sort_dir: mapping[sort_dir],
          href: "#{pages_visited_path(phrase)}?sort_key=#{sort_key}&sort_dir=#{dir}&page=#{page}",
        },
      )
    end

    column_map.values
  end

private

  attr_reader :search_options
end
