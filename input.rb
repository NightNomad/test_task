#!/usr/bin/env ruby

require 'slop'
require 'mechanize'
require 'json'

opts = Slop.parse do |o|
  o.string '--url', 'an URL for catalog'
  o.string '--filename', 'CSV filename'
end 

agent = Mechanize.new
page = agent.get(opts[:url])

links_list = page.links_with(:href => /Hills/, :text => 'View Details')

list = []

links_list.map do |l|
  base_page = l.click
  name = base_page.css('#product_family_heading').text
  weight = base_page.css('.title').text.delete("\t").gsub("\n", " ")
  delivery = base_page.css('.in-stock').text.delete("\n\t")
  price = base_page.css('.ours').text.delete("\t" "/Our Offer price:").gsub("\n", " ")
  id = base_page.css('.item-code').text.delete("\t" "/Quick Find:/").gsub("\n", " ")
  list.push(
    name: name,
    id: id,
    weight: weight,
    delivery: delivery,
    price: price
    )
end

data = JSON.pretty_generate(list)
puts data
File.open("#{opts[:filename]}.json", "w") { |f| f.write(data) }

