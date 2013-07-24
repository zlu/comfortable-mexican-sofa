class Cms::Mutation < ActiveRecord::Base
  
  ComfortableMexicanSofa.establish_connection(self)
  
  self.table_name = 'cms_mutations'
  
  # -- Relationships --------------------------------------------------------
  belongs_to :mutated,
    :polymorphic  => true,
    :inverse_of   => :mutations
    
  # -- Validations ----------------------------------------------------------
  validates :mutated, :identifier,
    :presence   => true
  validates :identifier,
    :uniqueness => {:scope => :mutated}
  
end