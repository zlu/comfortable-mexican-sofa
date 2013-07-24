require_relative '../../test_helper'

class CmsVersionTest < ActiveSupport::TestCase
  
  def test_fixtures_validity
    Cms::Version.all.each do |version|
      assert version.valid?, version.errors.full_messages.to_s
    end
  end
  
  def test_validations
    version = Cms::Snippet.new
    assert version.invalid?
    assert_has_errors_on version, :versioned, :page_id
  end
  
  def test_creation
    existing = cms_versions(:default)
    assert existing.is_active?
    
    assert_difference 'Cms::Version.count' do
      version = cms_pages(:default).versions.create
      assert version.is_active?
    end
    
    existing.reload
    refute existing.is_active?
  end
  
  def test_destroy
    assert_difference 'Cms::Version.count', -1 do
      assert_difference 'Cms::Block.count', -2 do
        cms_versions(:default).destroy
      end
    end
  end
  
end