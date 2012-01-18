Given /^I install the required modules with dependencies:$/ do |table|
  # table is a Cucumber::Ast::Table
  to_install = []
  table.hashes.each do |oerp_module|
    mod = IrModuleModule.find(:first, :domain => [['name','=', oerp_module[:name] ]], :fields =>['id','state', 'dependencies_id'])
    raise "no module named #{oerp_module[:name]} found" unless mod
    to_install << mod
  end
  puts '>>>>>>>>>>Installing modules and their dependencies'
  IrModuleModule.install_modules(to_install, dependencies=true)
  $utils.set_var('module_to_install',to_install)
  $utils.get_var('module_to_install').should be_true
end

Given /^I install the require modules:$/ do |table|
  # table is a Cucumber::Ast::Table
  to_install = []
  puts IrModuleModule.class
  table.hashes.each do |oerp_module|
      mod = IrModuleModule.find(:first, :domain => [['name','=', oerp_module[:name] ]], :fields =>['id','state'])
      unless mod
          raise "no module named #{oerp_module[:name]} found"
      end
      to_install.push(mod)
  end
  puts '>>>>>>>>>>Installing modules'
  puts to_install
  IrModuleModule.install_modules(to_install)
  $utils.set_var('module_to_install',to_install)
  $utils.get_var('module_to_install').should be_true
end

Then /^my modules should have been installed$/ do
  modules = $utils.get_var('module_to_install')
  modules_ids = modules.map{|x|x.id}
  modules_ids.each do | mod_id |
    mod = IrModuleModule.find(mod_id, :fields=>['id', 'state'])
    mod.should_not be_nil
    mod.state.should eq('installed')
  end
end


Given /^I have the module account installed$/ do
  IrModuleModule.find(:first, :domain => [['name','=', 'account']], :fields => ['id']).should_not be_nil
end

Given /^no account set$/ do
  $utils.ooor.load_models()
  AccountAccount.find(:all).should be_empty
end

def install_chart_account(oerp_module, digits)
    chart = IrModuleModule.find(:first, :domain => [['name','=', oerp_module]], :fields => ['id', 'state'])
    if chart.state == "installed"
      config_wizard = WizardMultiChartsAccounts.create(:code_digits => digits)
      begin
          config_wizard.execute()
      rescue Exception => e
        # Must catch exception because execute() return None
        pp "Chart of account generated ! "
      end
    else
      raise "#{oerp_module} chart module not found"
    end
end

Given /^I want to generate account chart from module "([^"]*)" with "([^"]*)" digits if no account chart is installed$/ do |oerp_module, digits|
    install_chart_account(oerp_module, digits.to_i)
end

Given /^I want to generate account chart from module "([^"]*)" with "([^"]*)" digits$/ do |oerp_module, digits|
    install_chart_account(oerp_module, digits) if AccountAccount.find(:all).empty?
end

When /^I generate the chart$/ do
end

Given /^I give all groups right access to admin user$/ do
  groups_ids = ResGroups.find(:all, :fields => ['id'])
  admin = ResUsers.find(1, :fields => ['id','groups_ids'])
  admin.groups_id = groups_ids.map{|x|x.id}
  admin.save()
end

Then /^accounts should be available$/ do
  AccountAccount.find(:first).should_not be_nil
end

Given /^I should have a company$/ do
  @cust_comp = ResCompany.find(:first)
  @cust_comp.should_not be_nil
end

Given /^I should have a company named "([^\"]*)"$/ do |name|
  @cust_comp = ResCompany.find(:first, :domain => [['name','=',name]])
  unless @cust_comp
    @cust_comp = ResCompany.new(:name=>name)
  end
end

Given /^I create another company named "([^\"]*)" with the following values :$/ do |name, table|
  if not ResCompany.find(:first, :domain => [['name','=',name]])
      @cust_comp = ResCompany.new()

      table.hashes.each do |data|
        eval("@cust_comp.#{data['key']}=#{data['value']}")
      end
      @cust_comp.name = name
      @cust_comp.save
  end
end


Then /^I set the company with the following data :$/ do |table|
  table.hashes.each do |data|
      eval("@cust_comp.#{data['key']} = #{data['value']}")
  end
  @cust_comp.save
  
end

Given /^I create the company main partner named "([^\"]*)" with the following data :$/ do |name, table|
  if not ResPartner.find(:first, :domain => [['name','=',name]])
      @cust_part = ResPartner.new()
      table.hashes.each do |data|
          eval("@cust_part.#{data['key']}=#{data['value']}")
      end
      @cust_part.name = name
      @cust_part.save
  else
      @cust_part = @cust_comp.partner_id
  end
end

Given /^I create the main address name "([^\"]*)" with the following data :$/ do |name, table|
  @cust_add = ResPartnerAddress.find(:first, :domain => [['name','=',name]])
  unless @cust_add
      @cust_add = ResPartnerAddress.new()
  end
  table.hashes.each do |data|
      eval("@cust_add.#{data['key']}=#{data['value']}")
  end
  @cust_add.name = name
  @cust_add.save
  @cust_part.address = [@cust_add.id]
  @cust_part.save
end


Then /^I set the company main partner with the following data :$/ do |table|
  # table is a Cucumber::Ast::Table
  @cust_comp = ResCompany.find(@cust_comp.id)
  @cust_part = @cust_comp.partner_id
  table.hashes.each do |data|
      eval("@cust_part.#{data['key']}=#{data['value']}")
  end
  @cust_part.save
end

Then /^I set the main address with the following data :$/ do |table|
    @cust_part =  ResPartner.find(@cust_part.id)
      if  @cust_part.address
        @cust_add = @cust_part.address[0]
      else
        @cust_add = ResPartner.new
      end
      table.hashes.each do |data|
          eval("@cust_add.#{data['key']}=#{data['value']}")
      end
      @cust_add.save
end

Then /^I update the address country code to (\w+)$/ do |code|
  country_id = ResCountry.find(:first, :domain => [['code','=',code]], :fields => ['id'])
  @cust_add.country_id = country_id.id
  @cust_add.save
end

Then /^we are all done$/ do
end


Given /^I install the following language :$/ do |table|
    @cust_table = table
    # XMLRPC::Config.const_set(:ENABLE_NIL_PARSER, true)
    # erpmodule = IrModuleModule.find(:first)
    table.hashes.each do |data|
        modules=IrModuleModule.find(:all, :domain => [['state','=','installed']], :fields => ['id'])
        module_ids=[]
        modules.each do |mod|
            module_ids.push(mod.id)
            begin
              IrModuleModule.update_translations([mod.id], data['lang'], {})
            rescue Exception => e
              # Must catch exception because update_translations return None
              pp "Translation updated : "+data['lang']
            end
        end
    end
end

Then /^the language should be available$/ do
  all_language_installed = true
  @cust_table.hashes.each do |data|
      unless ResLang.find(:first, :domain => [['code','=', data['lang'] ]], :fields=>['id']) 
          all_language_installed = true
      end
  end
  all_language_installed.should be_true
end


Given /^I have install "([^"]*)" language$/ do |code| #"
    ResLang.find(:first, :domain => [['code','=', code]], :fields => ['id']).should be_true
end

Given /^I set "([^"]*)" language to swiss formatting$/ do |code| #"
    lang = ResLang.find(:first, :domain => [['code','=',code]])
    lang.class.rpc_execute('write',[lang.id],:date_format => "%d-%m-%Y", :thousands_sep => "'")
end

Then /^"([^"]*)" language date format should have changed$/ do |lang| #"
end

Then /^the main company currency is "([^"]*)" with a rate of "([^"]*)"$/ do |code, ratevalue|
  curr = ResCurrency.find(:first, :domain=>[['name','=',code]])
  rate = curr.rate_ids[0]
  rate.should_not be_nil
  rate.rate = ratevalue.to_f
  rate.save
  curr.should_not be_nil 
  @cust_comp.currency_id = curr.id
  @cust_comp.save
end

Given /^the main company has a default_income_account set to "([^"]*)"$/ do |code| #"
  comp = ResCompany.find(:first)
  acc = AccountAccount.find(:first, :domain=>[['code','=',code]])
  acc.should_not be_nil
  comp.default_income_account = acc.id
  comp.save
end

Given /^the main company has a default payment_term set to "([^"]*)"$/ do |name|#"
  comp = ResCompany.find(:first)
  term = AccountPaymentTerm.find(:first, :domain=>[['name', '=', name]])
  term.should_not be_nil
  comp.default_payment_term = term.id
  comp.save
end


Given /^the company has the "([^"]*)" logo$/ do |logo| #"
    require 'base64'
    img = Base64.encode64(File.read(logo))
    @cust_comp.logo = img
    @cust_comp.save
end

Given /^his rml header set to "([^"]*)"$/ do |arg1| #"
  header = File.read(arg1)
  @cust_comp.rml_header = header
  @cust_comp.rml_header2 = header
  @cust_comp.save
end

Given /^there is a journal named "([^"]*)" of type "([^"]*)"$/ do |name, type|
  @journal = AccountJournal.find(:first, :domain=>[['name','=', name],['type','=',type]])
  @journal.should_not be_nil
end

Given /^the journal default debit account is set to "([^"]*)"$/ do |code| #"
  account = AccountAccount.find(:first, :domain=>[['code','=',code]], :fields=>['id', 'name'])
  account.should_not be_nil
  @journal.default_debit_account_id = account.id
  @journal.save
end

Given /^the journal default credit account is set to "([^"]*)"$/ do |code| #"
    account = AccountAccount.find(:first, :domain=>[['code','=',code]], :fields=>['id', 'name'])
    account.should_not be_nil
    @journal.default_credit_account_id = account.id
    @journal.save
end

Given /^all journals allow entry cancellation$/ do
  AccountJournal.find(:all, :fields=>['id', 'update_posted']).each do | journal|
      journal.update_posted =true
      journal.save
  end
end

Given /^there is an sequence named "([^"]*)"$/ do |name| #"
    @sequence = IrSequence.find(:first, :domain=>[['name','=', name]])
    @sequence.should_not be_nil
end

Given /^the sequence has the following data :$/ do |table|
    table.hashes.each do |data|
          eval("@sequence.#{data['key']}=#{data['value']}")
    end
    @sequence.save
end

Given /^there is a bank account named "([^"]*)" linked to partner "([^"]*)"$/ do |bname, pname|
   part = ResPartner.find(:first, :domain=>[['name','=',pname]])
   part.should_not be_nil
   @res_p_bank = ResPartnerBank.find(:first, :domain=>[['name','=',bname]])
   unless @res_p_bank
     @res_p_bank = ResPartnerBank.new()
   end
   @res_p_bank.partner_id = part.id
end

Given /^I set the bank account with the following data :$/ do |table|
    
     table.hashes.each do |data|
         eval("@res_p_bank.#{data['key']}=#{data['value']}")
     end
end

Given /^the bank account is linked to bank "([^"]*)"$/ do |code| #"
  bank = ResBank.find(:first, :domain=>[['code','=',code]])
  bank.should_not be_nil
  @res_p_bank.bank = bank.id
  @res_p_bank.save
end


Given /^I update the "([^"]*)" module$/ do |name| #"
  if name == 'all' 
      IrModuleModule.find(:all, :domain=>[['state','=','installed']]).each do |mod|
          mod.state = 'to upgrade'
          puts mod
          mod.save
      end
      
  else
    mod = IrModuleModule.find(:first, :domain=>[['name','=',name]])
    mod.should_not be_nil
    mod.state = 'to upgrade'
    mod.save
  end
end


Given /^I update the module list$/ do
  mod = IrModuleModule.find(:first )
  mod.should_not be_nil
  mod.call('update_list')
end

Given /^the company should have "([^"]*)" as parent$/ do |name| #"
  parent_comp = ResCompany.find(:first, :domain => [['name','=',name]])
  parent_comp.should_not be_nil
  @cust_comp.parent_id = parent_comp.id
end

Given /^there is a partner named "([^"]*)" with the following attribute$/ do |name, table| #"
@part = ResPartner.find(:first, :domain=>[['name','=',name]])
unless @part 
    @part = ResPartner.new()
end
table.hashes.each do |data|
    eval("@part.#{data['key']}=#{data['value']}")
end
@part.save
@part.should be_true
end

Given /^I set the and address with the following data for "([^"]*)":$/ do |name, table| #"
@part = ResPartner.find(:first, :domain=>[['name','=',name]])
@part.should be_true
@add = ResPartnerAddress.find(:first, :domain=>[['partner_id','=', @part.id]])
unless @add
    @add = ResPartnerAddress.new()
    @add.partner_id = @part.id
end
table.hashes.each do |data|
    eval("@add.#{data['key']}=#{data['value']}")
end
@add.save
@add.should be_true
end
