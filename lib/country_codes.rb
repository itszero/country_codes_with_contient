module CountryCodes # :nodoc:
  def self.method_missing(name, *args)  
    if match = /find_by_(.*)/.match(name.to_s)
      raise "1 argument expected, #{args.size} provided." unless args.size == 1
      
      request = match[1]     
      if valid_attributes.include?(request)  
        @countries[request][args[0].to_s.downcase] || nil_countries_hash
      else
        raise "#{request} is not a valid attribute, valid attributes for find_by_* are: #{valid_attributes.join(', ')}."
      end
    else
      raise NoMethodError.new("Method '#{name}' not supported")
    end
  end
  
  def self.valid_attributes
    @countries.keys
  end
  
  def self.nil_countries_hash
    hash = {}
    valid_attributes.map { |attribute| hash[attribute.to_sym] = nil }
    hash
  end
  
  def self.load_countries_from_yaml
    # Load countries
    countries_from_file = YAML::load(File.open("#{RAILS_ROOT}/vendor/plugins/country_codes/lib/countries.yml"))
    
    # Build indexes for each attribute
    @countries = {}    
    countries_from_file.first.keys.each do |key|
      @countries[key.to_s] = {}
      countries_from_file.each { |country| @countries[key.to_s][country[key].to_s.downcase] = country }
    end
  end
end
