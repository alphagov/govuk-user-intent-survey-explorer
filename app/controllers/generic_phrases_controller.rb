class GenericPhrasesController < ApplicationController
  def index
    @items = [
      {
        verb: "to find",
        adjective: "information",
      },
      {
        verb: "acquire somthing",
        adjective: "delivery",
      },
    ]
  end
end
