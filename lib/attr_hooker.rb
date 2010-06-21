# A class that let's you add (validation) hooks before and after setting
#  a value on a setter or getter method.

class AttrHooker
  def self.attr_hooker(*args)
    @accessors = args
  end

  def self.validate_by_type(name, value)
    @valid_types ||= {}
    if (@valid_types[name.to_sym] && ! value.kind_of?(@valid_types[name.to_sym]))
      raise "Dude, wrong type: #{value}(#{value.class.to_s}) should be a #{@valid_types[name.to_sym]}"
    end
  end

  def self.valid_type_for(name, type)
    @valid_types ||= {}
    @valid_types[name.to_sym] = type
  end

  def self.validate_accessible(name)
    if (!@accessors.include?(name.to_sym))
      raise "No such property, dude.  Try declaring it as an attr_hooker first."
    end  
  end

  def self.validate_this(name, value)
    validate_accessible(name)
    if value
      validate_by_type(name, value)
    end
    # You can add other kinds of validations here.
  end

  def method_missing(m, *args, &block)
    @values ||= {}
    m.to_s.match(/(\w*)(=)?/)
    name = $1
    operation = $2
    value = args[0]
    if  operation == '='
      self.class.validate_this(name, value)
      @values[name] = value
    else
      @values[name]
    end
  end 
end

class A < AttrHooker
  attr_hooker :name, :age
  valid_type_for :name, String
end
