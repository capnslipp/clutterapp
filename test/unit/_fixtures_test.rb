require 'test_helper'

class FixturesTest < ActiveRecord::TestCase
  
  def test_fixtures_are_valid
    fixture_table_names.each do |class_name|
      klass = class_name.to_s.classify.constantize
      klass.send(:find, :all).each do |object|
        assert object.valid?, "#{klass.name} fixture #{object} is invalid: «#{object.errors.full_messages.join(', ')}»"
      end
    end
  end
  
end
