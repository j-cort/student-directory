def input_students
  # create an empty array
  students = []
  # Repeat this code until no name is given
  while true do
    # list of acceptable letters for villain names to begin with
    acceptable_first_letters = ["D", "G", "I", "J", "M", "R", "S", "T", "X", "Z"]
    
    # list of acceptable cohort months 
    acceptable_month = ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]
    
    # is name acceptable
    name_ok = false
    
    # get name
    while !name_ok do
      puts "Enter student name"
      puts "To finish, just hit return twice"
      name = gets.chomp
      
      # validate name
      if !name.empty? && !acceptable_first_letters.include?(name[0]) && name.length > 11
        puts "Name must begin with (D, G, I, J, M, R, S, T, X, Z)"
        puts "Name must be fewer than 12 characters"
      elsif !name.empty? && !acceptable_first_letters.include?(name[0])
        puts "Name must begin with (D, G, I, J, M, R, S, T, X, Z)"
      elsif !name.empty? && name.length > 11
        puts "Name must be fewer than 12 characters"
      else   
        name_ok = true
      end
    end
    
    
    # break loop if name input is empty
    if name.empty?
      break
    else
      
      # get cohort  
      puts "Enter cohort"
      cohort = gets.chomp.downcase
      acceptable_month.include?(cohort) ? cohort = cohort.downcase.to_sym : cohort = :unknown
      
      # get weapon
      puts "Enter weapoon"
      weapon = gets.chomp
      weapon.empty? ? weapon = :unknown : weapon = weapon.downcase.to_sym 
      
      # add the villain hash to array
      students << {name: name, cohort: cohort, weapon: weapon}
    end
  end
  # return the array of students
  students
end



def print_header
  puts "The students of Villains Academy".center(100)
  puts "----------".center(110)
end

def print(students)
  number = 0
  while number < students.length
    puts "#{number + 1}. #{students[number][:name]}, #{students[number][:weapon]} (#{students[number][:cohort]} cohort)".center(100)
    number += 1
  end
end

def print_footer(names)
  puts "Overall, we have #{names.count} great students".center(100)
end

students = input_students
print_header
print(students)
print_footer(students)
