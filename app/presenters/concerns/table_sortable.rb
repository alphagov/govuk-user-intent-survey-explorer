module ::TableSortable
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

private

  def sortable_table_head(key, text, path, format = nil)
    format_options = format.nil? ? {} : { format: format }
    {
      text: text,
      format: "numeric",
      href: href(key, path),
    }
      .merge(sort_direction(key))
      .merge(format_options)
  end

  def href(key, link_path)
    direction_for_link = sort_dir
    if currently_sorting_by_key?(key)
      direction_for_link = opposite_sort_dir
    end

    sort_params = { sort_key: key, sort_dir: direction_for_link }
    public_send(link_path, search_options.merge(sort_params))
  end

  def opposite_sort_dir
    sort_dir == :desc ? :asc : :desc
  end

  def sort_direction(key)
    return {} unless currently_sorting_by_key?(key)

    mapping = {
      asc: "ascending",
      desc: "descending",
    }
    { sort_direction: mapping[sort_dir] }
  end

  def currently_sorting_by_key?(key)
    key == sort_key
  end

  def sort_key
    search_options[:sort_key]
  end

  def sort_dir
    search_options[:sort_dir].to_s.to_sym
  end
end
