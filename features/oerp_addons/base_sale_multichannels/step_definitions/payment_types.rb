Given /^I want to configure the following (TRUSTED|UNTRUSTED) Magento payment mode to (AUTOMATICALLY|MANUALLY) handle related sale orders workflow:$/ do |trust, mode, table|
  if trust == 'UNTRUSTED'
    xml_id = 'magentoerpconnect.payment_type1'
    order_policy = 'manual'
  elsif trust == 'TRUSTED'
    xml_id = 'magentoerpconnect.payment_type2'
    order_policy = 'prepaid'
  end
  atr_array = []
  table.hashes.each do |payment_mode|
    atr_array.push payment_mode['Magento payment mode code']
  end
  atr_array.should_not be_empty,
    "No code provided"
  name = atr_array.join(';')
  @base_payment = BaseSalePaymentType.find(:first, :domain=>[['name', '=', name]])
  unless @base_payment
    @base_payment = BaseSalePaymentType.new
  end
  @base_payment.name = name
  @base_payment.order_policy = order_policy
  if mode == 'AUTOMATICALLY'
    @base_payment.validate_order = true
    @base_payment.validate_invoice = true
  end
  @base_payment.save
 
  tmp = BaseSalePaymentType.find(xml_id)
  tmp.name = ''
  tmp.save
end

Given /^I "([^"]*)" partial picking on (TRUSTED|UNTRUSTED) payment mode$/ do |action, trust|
  ['allow', 'forbid'].should include(action),
    "action shoud be allow or forbid"
  if action == 'allow'
    picking_policy = 'direct'
  elsif trust == 'forbid'
    picking_policy = 'one'
  end
  @base_payment.should_not be_nil,
    'No payment sale payment type previously defined'
  @base_payment.picking_policy = picking_policy
  @base_payment.save
end

