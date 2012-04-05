Given /^I execute following sql:$/ do |sql|
  @openerp.sequel.run sql
end