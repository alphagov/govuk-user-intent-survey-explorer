module Searchable
  extend ActiveSupport::Concern

  # TODO: This module is used by detail pages that filter by date and by pages
  # that actually search for things. This is a bit muddled as it means that pages
  # that don't need searching ability have extra redundant functionality.
  # To solve this, we may want to separate out the date filtering into a separate module
  # so it can be used by detail pages that only require that while Searchable can
  # include that module for the functionality it needs

  included do
    helper_method :q, :from_date, :to_date, :from_date_as_datetime, :to_date_as_datetime, :sort_key, :sort_dir
  end

  def from_date
    search_options.fetch(:from_date, default_from_date)
  end

  def to_date
    search_options.fetch(:to_date, default_to_date)
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
    search_options[:q].to_s
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

private

  def search_options
    options = params.permit(:q, from_date: %i[day month year], to_date: %i[day month year]).merge({
      sort_key: sort_key,
      sort_dir: sort_dir,
      page: params[:page] || 1,
    })

    options[:verb] = verb if verb.present?
    options[:adjective] = adjective if adjective.present?

    options
  end

  def sort_dir
    params[:sort_dir] == "desc" ? :desc : :asc
  end

  def sort_key
    if params[:sort_key].present?
      allowed_sort_keys.include?(params[:sort_key]) ? params[:sort_key] : default_sort_key
    else
      default_sort_key
    end
  end

  def default_sort_key
    ""
  end

  def allowed_sort_keys
    []
  end

  def verb
    verb_param = params.permit(:verb).fetch(:verb, "")

    verb_results.include?(verb_param) ? verb_param : ""
  end

  def adjective
    adjective_param = params.permit(:adjective).fetch(:adjective, "")

    adjective_results.include?(adjective_param) ? adjective_param : ""
  end

  def verb_results
    Verb.unique_sorted.map(&:name)
  end

  def adjective_results
    Adjective.unique_sorted.map(&:name)
  end
end
