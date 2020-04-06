class SortPresenter
  attr_reader :q, :sort_key, :sort_direction

  def initialize(sort_key:, sort_direction:)
    @sort_key = sort_key
    @sort_direction = sort_direction.to_sym
  end
end
