require 'test/unit'
require 'yaml'

# Load and init
RAILS_ROOT = File.dirname(__FILE__) + '/../../../..'  # UGLY, but I don't have RAILS_ROOT here :(
require File.dirname(__FILE__) + '/../lib/country_codes'
CountryCodes.load_countries_from_yaml

# Test
class CountryCodesTest < Test::Unit::TestCase
  def test_find_by_name  
    assert_equal 'AU', CountryCodes.find_by_name('Australia')[:a2]
    assert_equal 'JP', CountryCodes.find_by_name('Japan')[:a2]
  end
  
  def test_missing_find_by_name
    assert_nil CountryCodes.find_by_name('MissingCountry')[:name]
  end
  
  def test_find_by_a2
    assert_equal 'Australia', CountryCodes.find_by_a2('AU')[:name]
    assert_equal 'Japan',     CountryCodes.find_by_a2('JP')[:name]
  end
  
  def test_missing_find_by_a2
    assert_nil CountryCodes.find_by_a2('MissingCountry')[:name]
  end
  
  def test_find_by_a3
    assert_equal 'Australia', CountryCodes.find_by_a3('AUS')[:name]
    assert_equal 'Japan',     CountryCodes.find_by_a3('JPN')[:name]
  end
  
  def test_missing_find_by_a3
    assert_nil CountryCodes.find_by_a2('MissingCountry')[:name]
  end
  
  def test_find_by_numeric
    assert_equal 'Australia', CountryCodes.find_by_numeric(36)[:name]
    assert_equal 'Japan',     CountryCodes.find_by_numeric(392)[:name]    
  end

  def test_missing_find_by_numeric
    assert_nil CountryCodes.find_by_numeric(-1)[:name]
  end
  
  def test_case_and_string_insensitivity
    assert_equal 'Australia', CountryCodes.find_by_name('AUSTRALIA')[:name]
    assert_equal 'Australia', CountryCodes.find_by_name('aUsTrAlIa')[:name]
    assert_equal 'Australia', CountryCodes.find_by_a2('aU')[:name]
    assert_equal 'Australia', CountryCodes.find_by_a3('AuS')[:name]    
    assert_equal 'Australia', CountryCodes.find_by_numeric('36')[:name]        
  end
  
  def test_bad_find_by_bad_name
    begin
      CountryCodes.find_by_number_of_penguins(73)
      flunk
    rescue RuntimeError => ex
      assert_equal 'number_of_penguins is not a valid attribute, valid attributes for find_by_* are: name, numeric, a2, a3.', ex.message
    end
  end
  
  def test_find_by_no_name
    begin
      CountryCodes.find_by_('What?!')
      flunk
    rescue RuntimeError => ex
      assert_equal " is not a valid attribute, valid attributes for find_by_* are: name, numeric, a2, a3.", ex.message
    end
  end
  
  def test_find_by_nothing_at_all
    begin
      CountryCodes.find_by('Huh?!')
      flunk
    rescue NoMethodError => ex
      assert_equal "Method 'find_by' not supported", ex.message
    end
  end
  
  def test_not_handled_method
    begin
      CountryCodes.take_over_country('Australia')
      flunk
    rescue NoMethodError => ex
      assert_equal "Method 'take_over_country' not supported", ex.message
    end
  end
end
