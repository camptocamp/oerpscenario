# Author Nicolas Bessi 2009 
# Contribs : Joël Grand-Guillaume
# copyright Camptocamp SA
require 'lib/ERPConnector'
require 'rubygems'
require 'ooor'
include Ooor

# Create an make a first login to be able to adds etra-function
$utils = ScenarioUtils.new
begin
    if $utils.ready? :
        $utils.login(user,pass)
    else 
        $utils.setConnexionfromConf()
    end
rescue Exception => e
    $utils.setConnexionfromConf()
end

# Add extra-functions
require 'lib/ERPFunctionAdds/Partner'
require 'lib/ERPFunctionAdds/Invoice'
