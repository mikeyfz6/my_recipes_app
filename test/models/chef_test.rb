require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: "Mikey", email: "mikey@example.com")
  end

  test "should be valid" do 
    assert @chef.valid?
  end

  test "chefname should be present" do 
    @chef.chefname = " "
    assert_not @chef.valid?
  end

  test "chefname should be less than 30 characters" do 
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end

  test "email should be present" do 
    @chef.email = ""
    assert_not @chef.valid?
  end

  test "email should be less than 255 characters" do 
    @chef.email = "a" * 256
    assert_not @chef.valid?
  end 

  test "email should accept the correct format" do 
    valid_emails = %w[ user@example.com MIKEY@gmail.com M.first@yahoo.ca john+smith@co.uk.org]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be vaild"
    end
  end

  test "email should reject invalid address" do 
    invalid_emails = %w[ user@example MIKEY@gmail,com M.first@yahoo. john+smith@co+uk+org]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "#{invalids.inspect} should be invaild"
    end
  end

  test "email should be unique and case insensitive" do 
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test "email should be lower case before hitting the db" do 
    mixed_email = "JohN@Example.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end
end