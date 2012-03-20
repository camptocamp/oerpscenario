Given /^I define the global configuration of the payment types with values:$/ do |table|
  # table is a | field   | value  |
  @global_payment_type = table
end

When /^I define a "([^"]*)" payment type pattern with values:$/ do |name, table|
  # table is a | field   | value  |
  @payment_types ||= {}
  # put in a list because we can inherit patterns in the next step
  # so we'll apply each pattern one by one
  @payment_types[name] = [table]
end

When /^the other values of "([^"]*)" pattern are those of "([^"]*)"$/ do |pattern, other_pattern|
  @payment_types.should include(pattern), "#{pattern} pattern does not exists"
  @payment_types.should include(other_pattern), "#{other_pattern} pattern does not exists"
  @payment_types[pattern] = @payment_types[other_pattern] + @payment_types[pattern]
end

Then /^I want to use the following payment codes with the "([^"]*)" payment type with reference "([^"]*)":$/ do |name, reference, table|
  # table is a | Payment Code |
  @payment_types.should have_key(name), "Missing configuration for payment type #{name}"

  codes = table.hashes.map { |data| data["Payment Code"] }
  codes.should_not be_empty, "No code provided"

  codes_list = codes.join(';')

  step %{I need a "BaseSalePaymentType" with reference "#{reference}"}
  @item.name = codes_list
  step "I update it with values:", @global_payment_type
  @payment_types[name].each do |pattern_table|
    step "I update it with values:", pattern_table
  end
  step "I save it"
end