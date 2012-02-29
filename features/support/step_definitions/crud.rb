Given /^I need a "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
  oerp_model = get_model_object(model)
  @item = oerp_model.find(reference)
  unless @item
    @item = oerp_model.new
    @item.ir_model_data_id = ['scenario', reference]
  end
end

def get_model_object(model)
  # allow to use "res.users" or "ResUsers"
  # capitalize 'res.users' to 'ResUsers'
  # if first char is a lowercase
  model = model.split('.').
            collect {|name_part| name_part.capitalize}.
            join if ('a'..'z').include? model[0, 1]

  Object.const_get(model)
end

def find_item_by_ref(model, reference)
  model_const = get_model_object(model)
  model_const.find(reference, :fields => %w(id))
end

def ref(model, reference)
  item = find_item_by_ref(model, reference)
  item.should_not be_nil, "No record found with the reference #{reference} on model : #{model}"
  item.id
end

def name(model, name)
  model_const = get_model_object(model)
  res = model_const.find(:all, :domain => [['name', '=', name]], :fields => %w(id))
  res.should_not be_nil, "No record found with the name #{name} on model #{model}"
  res.should have_exactly(1).items, "Multiple records found with the name #{name} on model #{model}"
  res[0].id
end

When /^I update it with values:$/ do |table|
  # table is a | key | value |
  table.hashes.each do |data|
    @item.send "#{data['key'].to_sym}=", eval(data['value'])
  end
end

When /^I save it$/ do
  @item.save
end

Then /^I should have a "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
  @item = find_item_by_ref(model, reference)
  @item.should_not be_nil
end

When /^I delete the "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
  item = find_item_by_ref(model, reference)
  if item
    item.should_not be_nil
  end
end