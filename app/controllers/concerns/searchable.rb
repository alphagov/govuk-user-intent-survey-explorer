module Searchable
  extend ActiveSupport::Concern

  included do
    helper_method :q, :from_date, :to_date, :from_date_as_datetime, :to_date_as_datetime
  end

  def search_params
    params.permit(:q, :sort_key, :sort_dir, from_date: %i[day month year], to_date: %i[day month year])
  end

  def from_date
    search_params.fetch(:from_date, default_from_date)
  end

  def to_date
    search_params.fetch(:to_date, default_to_date)
  end

  def default_from_date
    default = (DateTime.now - 7.days).beginning_of_day
    {
      day: default.day,
      month: default.month,
      year: default.year,
    }
  end

  def default_to_date
    default = DateTime.now
    {
      day: default.day,
      month: default.month,
      year: default.year,
    }
  end

  def q
    search_params[:q].to_s
  end

  def from_date_as_datetime
    date_parameters_to_datetime(from_date)
  end

  def to_date_as_datetime
    date_parameters_to_datetime(to_date)
  end

  def date_parameters_to_datetime(date_parameters)
    DateTime.new(date_parameters[:year].to_i, date_parameters[:month].to_i, date_parameters[:day].to_i)
  rescue ArgumentError
    nil
  end
end
