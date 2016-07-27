require 'mechanize'
require 'csv'

URL = 'https://www.viovet.co.uk/Pet_Foods_Diets-Dogs-Hills_Pet_Nutrition-Hills_Prescription_Diets/c233_234_2678_93/category.html'

agent = Mechanize.new
page = agent.get(URL)

links_list = page.links_with(:href => /Hills/, :text => 'View Details')

list = {}

links_list.map do |l|
  base_page = l.click
  @name = base_page.css('#product_family_heading').text
  @weight = base_page.css('.title').text
  @delivery = base_page.css('.button_wrap').text
  @price = base_page.css('.ours').text
  list.merge!(@name => [@weight, @delivery, @price])
end

#CSV.open('file.csv', 'w') do |c|
#  c << list
#end

