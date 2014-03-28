class Person < ActiveRecord::Base
  validates :name, :presence => true

  after_save :make_marriage_reciprocal

  def spouse
    if spouse_id.nil?
      nil
    else
      Person.find(spouse_id)
    end
  end

  def have_child(name, gender)
    child = Person.create(:name => name, :gender => gender, :parent1_id => id, :parent2_id => spouse_id )
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
