def prepare_args(args)
  mixed = args.strip.split('and')
  attrs = []
  arguments = []
  mixed.each do |set|
    tmp = set.split(':')
    attrs.push(tmp[0].strip)
    arguments.push(tmp[1].strip)
  end
  attrs_string = attrs.join('_and_')
  return attrs_string, arguments
end
require 'ruby-debug'
def get_items(action, qty, model, args)
  @found_items = nil
  @found_item = nil
  oclass =  Object.const_get(model.split('.').collect {|s| s.capitalize}.join)
  unique_mode = ['create', 'need', 'find or create']
  if qty == 'all'
    if unique_mode.include? action
      raise "#{unique_mode.inspect} does not allows 'all' keyword"
    end
    qty = 'all_'
  else
    qty = ''
  end
  command_map = {'create' => 'new', 'need' => 'find_or_initialize_by_', 'shoud_have' => "find_#{qty}by_", 'find' => "find_#{qty}by_", 'find or create' => 'find_or_initialize_by_'}
  comm_ext, arguments = prepare_args(args)
  if command_map[action] == 'create'
    if oclass.send(('find_by_'+comm_ext).to_sym, *arguments)
      raise "Error object allerady exist if this is not the wished behavior please use need keyword"
    end
  end
  res = oclass.send((command_map[action]+comm_ext).to_sym, *arguments) # I know in case or create we do 2 search but as there should be nul it cost almost nothing
  if @found_items.is_a? Array
    @found_items = res
  else
    @found_item = res
  end
end

def _manage_col_search(field_def, value)
  oclass = Object.const_get(field_def['relation'].split('.').collect {|s| s.capitalize}.join) # TODO use Scenario helper
  oid = nil
  if value.start_with? 'by '
    comm_ext, arguments = prepare_args(value.gsub('by ', ''))
    arguments.push({'fields'=>['id']})
    oid = oclass.send(('find_by_'+comm_ext).to_sym, *arguments)
  else
    eval "oid = oclass.#{value}"
  end
  unless oid
    raise "Can not find #{value}"
  end
  return oid
end

def manage_item_table(item, table)
  fields = {}
  fields.merge! item.class.many2one_associations
  fields.merge! item.class.one2many_associations
  fields.merge! item.class.many2many_associations
  
  table.hashes.each do |dict|
    if fields[dict['name']]
      rel_item = _manage_col_search(fields[dict['name']], dict['value'])
      eval "item.#{dict['name']} = rel_item.id"
    else
      eval "item.#{dict['name']} = dict['value']"
    end
  end    
end

Given /^I (create|need|should have|find|find or create) (a|all|last) "([^"]*)" with (.*)$/ do |action, qty, model, args|
 get_items(action, qty, model, args)
end

Given /^having$/ do |table|
  manage_item_table(@found_item, table)
  @found_item.save
end