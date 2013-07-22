require_relative '../../test_helper'

class CmsMutationTest < ActiveSupport::TestCase
  
  def test_fixtures_validity
    Cms::Mutation.all.each do |mutation|
      assert mutation.valid?, mutation.errors.inspect
    end
  end
  
  def test_validations
    mutation = Cms::Mutation.new
    assert mutation.invalid?
    assert_has_errors_on mutation, :mutated, :identifier
  end
  
  def test_validations_uniqueness
    mutation = Cms::Mutation.new(
      :mutated    => cms_mutations(:default).mutated,
      :identifier => cms_mutations(:default).identifier
    )
    assert mutation.invalid?
    assert_has_errors_on mutation, :identifier
  end
  
  def test_creation
    assert_difference 'Cms::Mutation.count' do
      Cms::Mutation.create(
        :mutated    => cms_blocks(:default_field_text),
        :identifier => 'test'
      )
    end
  end
  
end