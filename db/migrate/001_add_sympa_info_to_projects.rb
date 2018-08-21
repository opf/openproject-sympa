class AddSympaInfoToProjects < ActiveRecord::Migration[5.0]
  def self.up
    add_column :projects, :sympa_info, :text
  end

  def self.down
    remove_column :projects, :sympa_info
  end
end
