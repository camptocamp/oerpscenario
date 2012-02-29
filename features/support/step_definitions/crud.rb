When /^I save it$/ do
  @item.save
end

Then /^I should have a "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
  @item = Kernel.const_get(model).find(reference)
  @item.should_not be_nil
end

When /^I update it with values:$/ do |table|
  # table is a | name | 'UK Public Pricelist' |
  table.hashes.each do |data|
    @item.send "#{data['key'].to_sym}=", eval(data['value'])
  end
end

When /^I delete the "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
  item = Kernel.const_get(model).find(reference)
  item.should_not be_nil
  item.destroy
end