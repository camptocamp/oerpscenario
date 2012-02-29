
When /^I set the incoming mail new record on model "([^"]*)"$/ do  |model_name|
  model = IrModel.find(:first, :domain => [['name', '=', model_name]])
  model.should_not be_nil
  @item.object_id = model.id
end

When /^I test and confirm the fetchmail server with reference "([^"]*)"$/ do |mail_server_ref|
  server = FetchmailServer.find(mail_server_ref)
  server.should_not be_nil
  FetchmailServer.button_confirm_login([server.id])
  server = FetchmailServer.find(mail_server_ref)
  server.state.should eq('done'), "The mail server should be in state 'done' but it is not. The mail setup is probably wrong."
end