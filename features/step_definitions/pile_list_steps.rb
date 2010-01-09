=begin
“Given” defs
=end



=begin
“When” defs
=end



=begin
“Then” defs
=end

Then /^I should see the following Piles$/ do |table|
  table.hashes do |hash|
    Then %<I should see "#{hash[:pile_name]}">
  end
end

Then /^I should be see the "([^"]*)" header$/ do |arg1|
  Then %<I should see "#{hash[:pile_name]}" within "#item-area">
end
