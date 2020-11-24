class RemoveUnusedTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :blogs
    drop_table :blog_articles
    drop_table :brand_toolkit_contacts
    drop_table :forem_categories
    drop_table :marketing_attachments
    drop_table :marketing_calendars
    drop_table :marketing_comments
    drop_table :marketing_project_type_tasks
    drop_table :marketing_project_types
    drop_table :marketing_projects
    drop_table :marketing_tasks
    drop_table :toolkit_resource_types
    drop_table :toolkit_resources
    drop_table :tweets
  end

end
