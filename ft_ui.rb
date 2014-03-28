require 'bundler/setup'
Bundler.require(:default, :test)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu
  choice = nil
  until choice == 'x'
    puts "1: add person, 2: add marriage, 3: list all family tree members, x: exit"
    choice = gets.chomp
    case choice
    when '1'
      add_person
    when '2'
      add_marriage
    when '3'
      list_view
    when 'x'
      puts 'Goodbye'
    else
      puts 'invalid choice'
    end
  end
end

def add_person
  puts "Is this marrying into the family (m), or is this a new child (c)?"
  choice = gets.chomp
  if choice == 'm'
    puts "Name?"
    name = gets.chomp
    puts "Gender (m/f)?"
    gender = gets.chomp
    new_person = Person.create(:name => name, :gender => gender)
  elsif choice == 'c'
    add_child
  else
    puts 'Invalid choice'
    add_person
  end
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => spouse2.id)
  ascii_heart
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def list
  all_people.sort.each do |person|
    puts person.id.to_s + " " + person.name
  end
end

def list_view
  list
  puts "If you would like to see the next of kin for a person select their id, otherwise choose 'm' for Menu"
  choice = gets.chomp
  if choice == 'm'
    main_menu
  elsif choice.match /\d/
  current_person = Person.find(choice)
  current_family(current_person)
  else
    puts 'not a valid option'
    main_menu
  end
end

def add_child
  list
  puts 'Enter the id of a parent'
  parent = Person.find(gets.chomp)
  puts 'What is the child\'s name?'
  child_name = gets.chomp
  puts 'What is the child\'s gender?'
  child_gender = gets.chomp
  parent.have_child(child_name, child_gender)
end

def current_family(current_person)
  if current_person.spouse
    current_spouse = Person.find(current_person.spouse_id)
  end
  children = []
  all_people.each do |person|
    if person.parent1_id == current_person.id || person.parent2_id == current_person.id
      children << person.name
    end
  end
  print "Grandparents: "
  find_grandparents(find_parents(current_person)).each do |set|
    gps = []
    set.each do |gp|
      gps << gp.name
    end
    print gps.join(', ')
  end
  print "\nParents: "
  find_parents(current_person).each do |pa|
    print pa.name
  end
  print "\n"
  puts "#{current_person.name} #{'/ ' + current_spouse.name if current_person.spouse}"
  find_children(current_person).each do |set|
    kids = []
    set.each do |ch|
      kids << ch.name
    end
    kids.join(', ')
  end
  print "\n"
end

def find_parents(current_person)
    parents = []
    if current_person.parent1_id
      parent1 = Person.find(current_person.parent1_id)
      parents << parent1
    end
    if current_person.parent2_id
      parent2 = Person.find(current_person.parent2_id)
      parents << parent2
    end
    parents
end

def find_grandparents(parents)
  grandparents = []
  parents.each do |parent|
    grandparents << find_parents(parent)
  end
  grandparents
end

def find_children(current_person)
  children = []
  children << Person.all.where(parent1_id: current_person.id)
  children << Person.all.where(parent2_id: current_person.id)
  children
end

def all_people
  Person.all
end




def ascii_heart
  puts "
        @@@@@@           @@@@@@
      @@@@@@@@@@       @@@@@@@@@@
    @@@@@@@@@@@@@@   @@@@@@@@@@@@@@
  @@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @@@@@@@@@@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@@@@@@
          @@@@@@@@@@@@@@@@@@@
            @@@@@@@@@@@@@@@
              @@@@@@@@@@@
                @@@@@@@
                  @@@
                   @"
end
# Steve/Janie-Dan,Mike,Ellen

main_menu
