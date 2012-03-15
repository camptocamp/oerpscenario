Given /^I enable wiki on following models:$/ do |table|
  table.hashes.each do | model_name |
    model_name = model_name['name']
    model = IrModel.find_by_model(model_name, :fields=>['id', 'wiki_link'])
    model.should_not be_nil,
      "Can't find model #{model_name}"
    pp model
    model.wiki_link = true
    model.save
  end
end
