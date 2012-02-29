Given /^I define the global configuration of the payment types with values:$/ do |table|
  # table is a | field   | value  |
  @global_payment_type = table
end

When /^I define a "([^"]*)" payment type pattern with values:$/ do |name, table|
  # table is a | field   | value  |
  @payment_types ||= {}
  @payment_types[name] = table
end

Then /^I want to use the following payment codes with the "([^"]*)" payment type with reference "([^"]*)":$/ do |name, reference, table|
  # table is a | payment_code   |
  @payment_types.should have_key(name), "Missing configuration for payment type #{name}"

  codes = table.hashes.map { |data| data["Payment Code"] }
  codes.should_not be_empty, "No code provided"

  codes_list = codes.join(';')

  step %{I need a "BaseSalePaymentType" with reference "#{reference}"}
  @item.name = codes_list
  step "I update it with values:", @global_payment_type
  step "I update it with values:", @payment_types[name]
  step "I save it"
end