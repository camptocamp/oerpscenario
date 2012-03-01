Given /^I need an? "([^"]*)" with reference "([^"]*)"$/ do |model, reference|
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
  model = Ooor::OpenObjectResource.class_name_from_model_key(model) \
    if ('a'..'z').include? model[0, 1]

  Object.const_get(model)
end

def find_item_by_ref(model, reference)
  model_const = get_model_object(model)
  model_const.find(reference, :fields => %w(id))
end

module FieldDSL
  extend self

  def parse(ooor_model, field_name, value)
    if /ref\(? *['"]([a-zA-Z_.]+)['"] *\)?/.match(value)
      # ref('xmlid') or ref 'xmlid'
      relation_name = relation(ooor_model, field_name)
      parsed_value = mref(relation_name, $1)
    elsif /name\(? *['"](.+)['"] *\)?/.match(value)
      # name('My name') or name 'My name'
      relation_name = relation(ooor_model, field_name)
      parsed_value = mname(relation_name, $1)
    else
      parsed_value = eval(value)
    end
    parsed_value
  end

  def mref(model, reference)
    item = find_item_by_ref(model, reference)
    raise "No record found with the reference #{reference} on model : #{model}" unless item
    item.id
  end

  def mname(model, name)
    model_const = get_model_object(model)
    res = model_const.find(:all, :domain => [['name', '=', name]], :fields => %w(id))
    raise "No record found with the name #{name} on model #{model}" unless res
    raise "Multiple records found with the name #{name} on model #{model}" if res.count > 1
    res[0].id
  end

  def relation(ooor_model, field_name)
    field_definition = ooor_model.many2one_associations[field_name]
    field_definition['relation']
  end
  private :relation
end

When /^I update it with values:$/ do |table|
  # table is a | key | value |
  table.hashes.each do |data|
    value = FieldDSL.parse(@item.class, data['key'], data['value'])
    @item.send "#{data['key'].to_sym}=", value
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
