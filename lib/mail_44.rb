require 'pry'
require 'rspec'
require 'rubocop'
require 'nokogiri'
require 'open-uri'
require 'csv'

page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/loire-atlantique.html"))

PAGE_URL = "http://annuaire-des-mairies.com/loire-atlantique.html"

# définition de la classe ville ==> mail
class MailVille44

  # récupérer le mail
  def get_the_email(page)
  page = Nokogiri::HTML(open(page))
  text = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text 
    if text != "" 
      return text 
    else 
      return "AUCUN EMAIL" 
    end
  end

  # récupérer le nom des villes et y associer une url
  def get_the_url(page) 
    url = page.chomp("loire-atlantique.html") 
    page = Nokogiri::HTML(open(page))
    municipalities = [] 
    page.css("a.lientxt").each do |municipality| 
    municipalities << {municipality.text => get_the_email(url + municipality['href'].sub!("./", ""))}
    end
    return municipalities 
  end

  # méthode pour sauvegarder la liste sur un fichier csv
  def save_as_csv(municipalities)
    CSV.open("/home/paul/Documents/week3/Gmail/db/email.csv", "wb")  do |csv| 
    municipalities.each do |municipality|
    municipality.each_pair do |ville, mail|
    csv << [ville, mail]
    end
    end
    end
  end

  # le bouquet final pour que tout fonctionne 
  def perform
    municipalities = get_the_url(PAGE_URL)
    for municipality in municipalities 
      puts municipality
    save_as_csv(municipalities)
    end
  end

end