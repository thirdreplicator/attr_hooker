require 'lib/attr_hooker'

describe AttrHooker do
  before(:each) do
    class Person < AttrHooker
      attr_hooker :name
    end   
    @p = Person.new
  end

  it "should validate a property was declared before setting it" do
    lambda{@p.age = 0}.should raise_error
  end

  it "should set a value as though it were an attribute for declared values" do
    @p.name = "Fred"
    @p.name.should == "Fred"
  end

  it "should check types for attributes with declared types" do
    class Person < AttrHooker
      valid_type_for :name, String
    end
    lambda{@p.name = "Fred"}.should_not raise_error
    lambda{@p.name = 42}.should raise_error
    lambda{@p.name = :fried_fish}.should raise_error
  end 
end
