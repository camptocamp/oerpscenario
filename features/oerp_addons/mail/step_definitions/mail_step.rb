Given /^I have no outgoing mail conf named "([^"]*)"$/ do |name|
  IrMail_server.find(:all, :domain=>[[:name, '=', name]]).each do | conf|
    conf.destroy
  end
end

Given /^I have a outgoing mailconf  named "([^"]*)"$/ do |name|
  out_conf = IrMail_server.find(:first, :domain=>[[:name, '=', name]])
  unless out_conf
    out_conf = IrMail_server.new
  end
  out_conf.name = name
  out_conf.save
  out_conf.should_not be_nil
end

Given /^I have a incoming mail conf named "([^"]*)"$/ do |name|
  @in_conf = FetchmailServer.find(:first, :domain=>[[:name, '=', name]])
  unless @in_conf
     @in_conf = FetchmailServer.new
  end
  @in_conf.name = name
end

Given /^the incoming conf generate "([^"]*)"$/ do |obj|
  @in_conf.should_not be_nil
  obj = IrModel.find(:first, :domain=>[[:name, '=', obj]])
  obj.should_not be_nil
  @in_conf.object_id = obj.id

end

When /^I save the incoming conf it should be ok$/ do
  @in_conf.should_not be_nil
  @in_conf.save
  @in_conf.should_not be_nil
  
end

Given /^I activate the incoming conf$/ do
  @in_conf.should_not be_nil
  @in_conf.call('button_confirm_login', [@in_conf.id])
  @in_conf = FetchmailServer.find(@in_conf.id)
  @in_conf.state.should eq('done')
end