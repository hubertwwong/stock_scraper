require 'rubygems'
require 'capybara'
require 'capybara/dsl'

class ScrapeUtil
  # helpers..
  
  # takes an array of strings.
  # return true if all of the strings are in the page.
  def self.has_content_and?(pg, page_strs)
    valid_page = true
    
    # check if strings match.
    page_strs.each do |cur_str|
      valid_page = valid_page && (pg.has_content? cur_str)
    end
    
    valid_page
  end
  
  # same as the and but if it finds any string, this returns true.
  def self.has_content_or?(pg, page_strs)
    valid_page = false
    page_strs.each do |cur_str|
      valid_page = valid_page || (pg.has_content? cur_str)
      
      # break out of the loop if the page is true.
      # you only care if one item on the page.
      if valid_page == true
        break
      end
    end
    
    valid_page
  end
  
end