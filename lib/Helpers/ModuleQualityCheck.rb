###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Author Joel Grand-Guillaume 2009 
#    Copyright Camptocamp SA
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 Afero of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################
require 'pp'
require 'rubygems'
require 'ooor'


# Add useful methode on base module quality check module handling
##############################################################################
begin
    if Object.const_defined?'ModuleQualityCheck':
        ModuleQualityCheck.class_eval do 
            ##########################################################################
            # Print out the tests result
            # Input :
            #  - qualityinstance : A Valid ModuleQualityCheck instance
            # Return
            #  - Nice string to print
            # Usage Example:
            # print ModuleQualityCheck.get_formatted_results(qualityinstance)
            def self.get_formatted_results(qualityinstance)
                result=true
                title="\n"
                title+="Module : " + qualityinstance.name + " Scored : " + qualityinstance.final_score + "\n"
                title+='-------------------------------------------------------'

                details="\n"
                qualityinstance.check_detail_ids.each do |detail|
                    details+=detail.name + " (State: " + detail.state + ") Scored : " + detail.score.to_s + "\n"
                    details+="Ponderation: "+ detail.ponderation.to_s + "\n"
                    details+="Note: "+ detail.note + "\n"
                end
                result=title+details

                if result :
                    return result
                else
                    raise "!!! --- HELPER ERROR :get_formatted_results !"
                end
            end
        end  

        ModuleQualityDetail.class_eval do 
            ##########################################################################
            # Print out the tests result
            # Input :
            #  - 
            # Return
            #  - Nice print
            # Usage Example:
            # modules_ids = My_ModuleQualityInstance.print_formatted_results()
            # def print_formatted_results()
            #     
            #     if result :
            #         return result
            #     else
            #          raise "!!! --- HELPER ERROR :get_supplier found #{type} named #{name}, but without adresses"
            #     end
            # end
        end
    else
        puts "WARNING : Quality Helpers can't be initialized -> Quality module isn't installed !!!"

    end
rescue Exception => e
    puts "WARNING : base_quality_module isn't installed !!!"
end
