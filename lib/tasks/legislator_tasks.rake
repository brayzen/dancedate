require 'pp'
require 'pry'
Dir['./lib/tasks/legislators/*.rb'].each{ |file| require file }
Dir['./lib/scrapers/*.rb'].each{ |file| require file }
@legislator_image_path = 'db/raw/images'

namespace :legislators do
  task create: :environment do
    create_legislators
    create_executives
  end

  task reset: :environment do
    Legislator.destroy_all
    create_legislators
    create_executives
  end

  task :find_images, [:replace] => :environment do |t, args|
    find_images args[:replace]
  end

  task image_count: :environment do
    pp Dir['./db/raw/images/*'].count
  end
end

def create_legislators
  legislator_file = './db/raw/legislators-current.yaml'
  social_file = './db/raw/legislators-social-media.yaml'
  LegislatorFactory.legislators_from_yaml legislator_file, social_file
end

def find_images(replace = false)
  skip_saved = !replace
  scraper = WikipediaScraper::LegislatorImages.new @legislator_image_path
  failed = []
  Legislator.all.each do |legislator|
    next if skip_saved && has_image?(legislator)
    l_name = legislator.name
    wiki = legislator.wikipedia
    begin
      scraper.get_legislator l_name, wiki
      pp l_name
    rescue Exception => e
      binding.pry
      failed.push l_name
    end
  end

  pp failed
end

def has_image?(legislator)
  l_name = legislator.name.downcase.gsub(' ', '_')
  Dir["./#{@legislator_image_path}/*"].any?{ |img| img.include? l_name }
end
