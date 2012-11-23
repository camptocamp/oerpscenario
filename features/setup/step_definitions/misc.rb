Given /^I create an "(.*?)" export for model "(.*?)" with following columns:$/ do |export_name, model, table|
  export = IrExports.find_by_name(export_name, :fields=>['id', 'name'])
  unless export
    export = IrExports.new(:name=>export_name)
  end
  export.resource = model
  export.save
  l_ids = IrExportsLine.search([['export_id', '=', export.id]])
  IrExportsLine.unlink(l_ids)
  table.hashes.each do | col |
    export_line = IrExportsLine.new(:name=>col[:name], :export_id=> export.id).save
  end
end