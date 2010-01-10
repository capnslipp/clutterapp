=begin
“Given” defs
=end



=begin
“When” defs
=end



=begin
“Then” defs
=end

Then /^I should see (\[[^\]]+\])$/ do |data_str|
  Then %<I should see "#{data_from_str(data_str)}">
end

Then /^I should see(?: a)? (\[[^\]]+\]) link$/ do |data_str|
  Then %<I should see "#{data_from_str(data_str)}" within "a">
end
