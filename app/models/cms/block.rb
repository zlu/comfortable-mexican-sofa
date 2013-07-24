class Cms::Block < ActiveRecord::Base
  
  ComfortableMexicanSofa.establish_connection(self)
  
  self.table_name = 'cms_blocks'
  
  # -- Relationships --------------------------------------------------------
  belongs_to :version
  
  has_many :mutations,
    :as         => :mutated,
    :dependent  => :destroy,
    :autosave   => true,
    :inverse_of => :mutated
  has_many :files,
    :autosave   => true
    
  delegate :page, :to => :version
  
  # -- Callbacks ------------------------------------------------------------
  before_save :prepare_files
  
  # -- Validations ----------------------------------------------------------
  validates :identifier,
    :presence   => true
  
  # -- Instance Methods -----------------------------------------------------
  # Tag object that is using this block
  def tag
    @tag ||= page.tags(true).detect{|t| t.is_cms_block? && t.identifier == identifier}
  end
  
  # Writer for block mutations. Accepts a hash where key is identifier and value
  # decides if it needs to be added or removed.
  def mutator_identifiers=(values)
    return unless values.is_a?(Hash)
    values.each do |identifier, checked|
      checked = checked.to_i == 1
      existing = self.mutations.detect{|v| v.identifier == identifier}
      if checked && !existing
        self.mutations.build(:identifier => identifier)
      elsif !checked && existing
        existing.mark_for_destruction
      end
    end
  end
  
protected
  
  def prepare_files
    temp_files = [self.content].flatten.select do |f|
      %w(ActionDispatch::Http::UploadedFile Rack::Test::UploadedFile).member?(f.class.name)
    end
    
    # only accepting one file if it's PageFile. PageFiles will take all
    single_file = self.tag.is_a?(ComfortableMexicanSofa::Tag::PageFile)
    temp_files = [temp_files.first].compact if single_file
    
    temp_files.each do |file|
      self.files.collect{|f| f.mark_for_destruction } if single_file
      self.files.build(:site => self.page.site, :dimensions => self.tag.try(:dimensions), :file => file)
    end
    
    self.content = nil unless self.content.is_a?(String)
  end
end
