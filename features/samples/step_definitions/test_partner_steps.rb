#Author Nicolas Bessi 2009 
#copyright Camptocamp SA
Before do
    @part = false
end

Given /^I made a search on a partner named (\w+)$/ do |name|
   @part = ResPartner.find(:first, :domain=>[['name', '=', name],['active','=',1]])
end

Then /^the result  should be true$/ do
  puts @part
  @part.should be_true
end

Then /^the country code should be (\w+)$/ do |country|
    res = false
    @part.address.each do |add|
        if add.country_id.code == country :
          res = true
          break
        end
    res.should be_true 
    end
end


