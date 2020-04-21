module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime("%d-%m-%y at %H:%M")
  end
end
