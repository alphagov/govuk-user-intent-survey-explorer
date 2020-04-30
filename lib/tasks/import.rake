namespace :import do
  desc "Import data from tmp/data.csv"
  task import_data: :environment do |_, _|
    Import.new.call
  end
end
