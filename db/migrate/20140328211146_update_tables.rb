class UpdateTables < ActiveRecord::Migration
  def change
    remove_column :people, :parent1_id, :int
    remove_column :people, :parent2_id, :int

    create_table :parents do |t|
      t.belongs_to :person
    end

    create_table :children do |t|
      t.belongs_to :person
    end

    create_table :children_parents do |t|
      t.belongs_to :child
      t.belongs_to :parent
    end
  end
end
