class Cms::VersionedContent < ActiveRecord::Base
  
  self.table_name = 'cms_versioned_contents'
  
  # -- Relationships --------------------------------------------------------
  belongs_to :versionable,
    :polymorphic => true
    
  has_many :blocks,
    :dependent => :destroy
  
end