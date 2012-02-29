Given /^I need a "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
  oerp_model = Kernel.const_get(model)
  @item = oerp_model.find(reference)
  unless @item
    @item = oerp_model.new
    @item.ir_model_data_id = ['scenario', reference]
  end
end

When /^I update it with values:$/ do |table|
  # table is a | name | 'UK Public Pricelist' |
  table.hashes.each do |data|
    @item.send "#{data['key'].to_sym}=", eval(data['value'])
  end
end

When /^I save it$/ do
  @item.save
end

Then /^I should have a "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
  @item = Kernel.const_get(model).find(reference)
  @item.should_not be_nil
end

When /^I delete the "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
  item = Kernel.const_get(model).find(reference)
  if item
    item.should_not be_nil
  end
end