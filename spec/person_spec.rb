require 'spec_helper'

describe Person do
  it { should validate_presence_of :name }

  context '#spouse' do
    it 'returns the person with their spouse_id' do
      earl = Person.create(:name => 'Earl', :gender => 'male')
      steve = Person.create(:name => 'Steve', :gender => 'male')
      steve.update(:spouse_id => earl.id)
      steve.spouse.should eq earl
    end

    it "is nil if they aren't married" do
      earl = Person.create(:name => 'Earl')
      earl.spouse.should be_nil
    end
  end

  it "updates the spouse's id when it's spouse_id is changed" do
    earl = Person.create(:name => 'Earl', :gender => 'm')
    steve = Person.create(:name => 'Steve', :gender => 'm')
    steve.update(:spouse_id => earl.id)
    earl.reload
    earl.spouse_id.should eq steve.id
  end

  describe '#have_child'do
    it 'assigns parent1 and parent2 ids to a child of these parents' do
      earl = Person.create(:name => 'Earl', :gender => 'm')
      steve = Person.create(:name => 'Steve', :gender => 'm')
      steve.update(:spouse_id => earl.id)
      steve.have_child('Janie','f').parent2_id.should eq earl.id
    end
  end

  it 'assigns only one parent to the new child if the parent does not have a spouse' do
    steve = Person.create(:name => 'Steve', :gender => 'm')
    steve.have_child('Janie','f').parent2_id.should be_nil
  end


end


