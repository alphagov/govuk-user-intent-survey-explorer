namespace :import do
  desc "Import data from tmp/data.csv"
  task :import_data => :environment do |_, args|
    Import.new.call
  end
end
