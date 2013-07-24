class Cms::Version < ActiveRecord::Base
  
  ComfortableMexicanSofa.establish_connection(self)
  
  self.table_name = 'cms_versions'
  
  # -- Relationships --------------------------------------------------------
  belongs_to :versioned,
    :polymorphic  => true
    
  has_many :blocks,
    :autosave     => true,
    :dependent    => :destroy
    
  # -- Callbacks ------------------------------------------------------------
  after_create :set_as_active!
  
  # -- Scopes ---------------------------------------------------------------
  scope :active, -> {
    where(:is_active => true)
  }
  
protected

  def set_as_active!
    self.versioned.versions.where('id <> ?', self.id).update_all(:is_active => false)
    self.update_column(:is_active, true)
  end
  
end