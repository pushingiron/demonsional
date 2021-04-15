require "test_helper"

class EnterpriseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @enterprise = enterprises(:one)
  end

  test "valid enterprise" do
    enterprise = Enterprise.new(@enterprise)
    assert enterprise.valid?
  end
end
