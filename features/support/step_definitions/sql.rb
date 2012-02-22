Given /^I execute following sql:$/ do |sql|
  $utils.sequel.run sql
end