#Author Nicolas Bessi 2009 
#copyright Camptocamp SA
Before do
    @utils = ScenarioUtils.new
    @part = false
end

Given /^I made a search on a partner named (\w+)$/ do |name|
   @part = ResPartner.find(:first, :domain=>[['name', '=', name],['active','=',1]])
   puts @part
   @part.should be_true
end

Then /^the result  should be true$/ do
  @part.should be_true
end

Then /^the country code should be (\w+)$/ do |country|
  @part.address[0].country_id.code.should == country
end

