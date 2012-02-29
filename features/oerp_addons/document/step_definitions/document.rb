Given /^I have a media storage called "([^"]*)" of type "([^"]*)" owned by "([^"]*)"$/ do |name, type, user|
  storage = DocumentStorage.find(:first, :domain => [['name','=',name]])
  unless storage
    storage = DocumentStorage.new()
  end
  user_obj = ResUsers.find(:first, :domain => [['name','=',user]])
  user_obj.should be_true
  if storage.name != name and storage.user_id != user_obj.id and storage.type != type
    storage.name = name
    storage.user_id = user_obj.id
    storage.type = type
    storage.save()
  end
  storage.should be_true
end

Given /^all directories are linked to the "([^"]*)"$/ do |storage_name|
  directories = DocumentDirectory.find(:all)
  storage = DocumentStorage.find(:first, :domain => [['name','=',storage_name]])
  storage.should be_true
  directories.each do |dir|
    dir.storage_id = storage.id
    dir.save()
  end
end

Given /^there is a ged folder named "([^"]*)" related to "([^"]*)" object$/ do |name, irmodel| #"
    doc = DocumentDirectory.find(:first, :domain=>[['name','=', name]])
    unless doc
        doc = DocumentDirectory.new
        doc.name = name
        doc.create
    end
    dirmodel =  IrModel.find(:first, :domain=>[['model','=',irmodel]])
    dirmodel.should_not be_nil
    doc.ressource_type_id = dirmodel.id
    doc.content_ids=[]
    doc.call('write', [doc.id], {'ressource_type_id'=>dirmodel.id}, context={'lang'=>'en_US'})
    #doc.save(context={'lang'=>'en_US'})
end

Given /^the invoice report has no reload from attachement$/ do
 act = IrActionsReportXml.find(:first, :domain=>[['name','=','Invoices']], :fields=>['id','attachment_use'])  
 act.should_not be_nil
 act.attachment_use = false
 act.save
end

Given /^the transacion folder should be empty$/ do
    begin
        `rm -rf #{@path}`
    rescue Exception => e
        $utils.log.debug("DEBUG : File empty #{e.to_s}")
    end
    File.exists?(@path).should be_false
    
end

Given /^I print the first invoice$/ do
  client = XMLRPC::Client.new2("http://#{ $utils.config[:host]}:#{$utils.config[:port]}/xmlrpc/common")
  uid = client.call('login',$utils.config[:dbname],$utils.config[:pwd], $utils.config[:pwd])
  client = XMLRPC::Client.new2("http://#{ $utils.config[:host]}:#{$utils.config[:port]}/xmlrpc/report")
  r_id = client.call('report',$utils.config[:dbname], uid, $utils.config[:pwd], 'account.invoice', [1], {'model'=> 'account.invoice', 'id'=> 1, 'report_type'=>'pdf'})
  state = false
  while state == false
    report = client.call('report_get',$utils.config[:dbname], uid, $utils.config[:pwd], r_id)
    state=report['state']
  end
end



Then /^I should have something in the transacion folder$/ do
  Dir.new(@path).entries.empty?.should be_false
end
Given /^I rename the storage media "([^"]*)" to "([^"]*)"$/ do |storage_name, new_storage_name|
  @item = DocumentStorage.find(:first, :domain => [['name', '=', storage_name]])
  if @item
    @item.name = new_storage_name
    # openerp crashes if these columns are in the update
    @item.attributes.delete('write_date')
    @item.associations.delete('write_uid')
    @item.associations.delete('create_uid')
    @item.attributes.delete('create_date')
    @item.save
  else
    @item = DocumentStorage.find(:first, :domain => [['name', '=', new_storage_name]])
  end
  @item.should_not be_nil
end
