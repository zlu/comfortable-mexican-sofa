class CreateCms < ActiveRecord::Migration
  
  def change
    
    text_limit = case ActiveRecord::Base.connection.adapter_name
      when 'PostgreSQL'
        { }
      else
        { :limit => 16777215 }
      end
    
    # -- Sites --------------------------------------------------------------
    create_table :cms_sites do |t|
      t.string :label,        :null => false
      t.string :identifier,   :null => false
      t.string :hostname,     :null => false
      t.string :path
      t.string :locale,       :null => false, :default => 'en'
    end
    add_index :cms_sites, :hostname
    
    # -- Layouts ------------------------------------------------------------
    create_table :cms_layouts do |t|
      t.integer :site_id,     :null => false
      t.integer :parent_id
      t.string  :app_layout
      t.string  :label,       :null => false
      t.string  :identifier,  :null => false
      t.text    :content,     text_limit
      t.text    :css,         text_limit
      t.text    :js,          text_limit
      t.integer :position,    :null => false, :default => 0
      t.timestamps
    end
    add_index :cms_layouts, [:parent_id, :position]
    add_index :cms_layouts, [:site_id, :identifier], :unique => true
    
    # -- Pages --------------------------------------------------------------
    create_table :cms_pages do |t|
      t.integer :site_id,         :null => false
      t.integer :layout_id
      t.integer :parent_id
      t.integer :target_page_id
      t.integer :position,        :null => false, :default => 0
      t.integer :children_count,  :null => false, :default => 0
      t.timestamps
    end
    add_index :cms_pages, [:parent_id, :position]
    
    # -- Page Contents ------------------------------------------------------
    create_table :cms_page_contents do |t|
      t.integer :page_id,   :null => false
      t.string  :slug
      t.string  :full_path, :null => false
      t.string  :label,     :null => false
    end
    add_index :cms_page_contents, :page_id
    add_index :cms_page_contents, :full_path
    
    # -- Page Blocks --------------------------------------------------------
    create_table :cms_blocks do |t|
      t.integer   :versioned_content_id,  :null => false
      t.string    :identifier,            :null => false
      t.text      :content,               text_limit
      t.timestamps
    end
    add_index :cms_blocks, [:versioned_content_id, :identifier]
    
    # -- Snippets -----------------------------------------------------------
    create_table :cms_snippets do |t|
      t.integer :site_id,     :null => false
      t.string  :label,       :null => false
      t.string  :identifier,  :null => false
      t.text    :content,     text_limit
      t.integer :position,    :null => false, :default => 0
      t.timestamps
    end
    add_index :cms_snippets, [:site_id, :identifier], :unique => true
    add_index :cms_snippets, [:site_id, :position]
    
    # -- Files --------------------------------------------------------------
    create_table :cms_files do |t|
      t.integer :site_id,           :null => false
      t.integer :block_id
      t.string  :label,             :null => false
      t.string  :file_file_name,    :null => false
      t.string  :file_content_type, :null => false
      t.integer :file_file_size,    :null => false
      t.string  :description,       :limit => 2048
      t.integer :position,          :null => false, :default => 0
      t.timestamps
    end
    add_index :cms_files, [:site_id, :label]
    add_index :cms_files, [:site_id, :file_file_name]
    add_index :cms_files, [:site_id, :position]
    add_index :cms_files, [:site_id, :block_id]
    
    # -- Variations ---------------------------------------------------------
    create_table :cms_variations do |t|
      t.string  :identifier,    :null => false
      t.string  :content_type,  :null => false
      t.integer :content_id,    :null => false
    end
    add_index :cms_variations, [:content_type, :content_id]
    add_index :cms_variations, :identifier
    
    # -- Versioned Content --------------------------------------------------
    create_table :cms_versioned_contents do |t|
      t.string    :versionable_type,  :null => false
      t.integer   :versionable_id,    :null => false
      t.boolean   :is_active,         :null => false, :default => false
      t.datetime  :published_at
      t.text      :cache,             text_limit
    end
    add_index :cms_versioned_contents, [:versionable_type, :versionable_id],
      :name => 'index_cms_versioned_contents_on_versionable'
    add_index :cms_versioned_contents, :is_active
    add_index :cms_versioned_contents, :published_at
    
    # -- Categories ---------------------------------------------------------
    create_table :cms_categories, :force => true do |t|
      t.integer :site_id,          :null => false
      t.string  :label,            :null => false
      t.string  :categorized_type, :null => false
    end
    add_index :cms_categories, [:site_id, :categorized_type, :label], :unique => true
    
    create_table :cms_categorizations, :force => true do |t|
      t.integer :category_id,       :null => false
      t.string  :categorized_type,  :null => false
      t.integer :categorized_id,    :null => false
    end
    add_index :cms_categorizations, [:category_id, :categorized_type, :categorized_id], :unique => true,
      :name => 'index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id'
  end
  
end

