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
    Then %<I should see "#{hash[:name]}">
    Then %<I should see "#{hash[:path]}">
  end
end
