@students = []
@cohorts = []

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
      name = STDIN.gets.chop
      
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
      cohort = STDIN.gets.chomp.downcase
      acceptable_month.include?(cohort) ? cohort = cohort.downcase.to_sym : cohort = :unknown
      
      # get weapon
      puts "Enter weapon"
      weapon = STDIN.gets.chomp
      weapon.empty? ? weapon = :unknown : weapon = weapon.downcase.to_sym 
      
      # add the villain hash to array
      students << {name: name, cohort: cohort, weapon: weapon}
    end
  end
  # assign array to @students instance variable
  @students = students
end

def print_header
  puts "The students of Villains Academy".center(100)
  puts "----------".center(100)
end

def print_students_list
  number = 0
  while number < @students.length
    puts "#{number + 1}. #{@students[number][:name]}, #{@students[number][:weapon]} user (#{@students[number][:cohort]} cohort)".center(100)
    number += 1
  end
end

def print_footer
  @students.count != 1 ? (puts "Overall, we have #{@students.count} great students".center(100)) : 
    (puts "Overall, we have #{@students.count} great student".center(100))
end

def get_cohorts
  @students.map { |student| student[:cohort]}.uniq
end

def print_by_cohort
  @cohorts.each do |cohort|
    puts "#{cohort.to_s.upcase} COHORT"
    @students.each_with_index do |student, index|
      if student[:cohort] == cohort
        puts "#{student[:name]}, #{student[:weapon]} user"
      end
    end
    puts "\n"
  end
end

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from file"
  puts "9. Exit"
end

def show_students
  if !@students.empty?
    print_header
    print_students_list
    print_footer
    print_by_cohort
  else
    puts "There are no students in our academy."
  end
end

def save_students
  # open the file for writing
  file = File.open("students.csv", "w")
  # iterate over the array of students
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
end

def try_load_students
  filename = ARGV.first
  if filename.nil?
    load_students
  elsif File.exists?(filename)
    load_students(filename)
      puts "loaded #{@students.count} from #{filename}"
  else
    puts "Sorry, #{filename} doesn't exist"
    puts "loading 'students.csv' instead"
    load_students
  end
end

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  file.readlines.each do |line|
  name, cohort = line.chomp.split(",")
    @students << {name: name, cohort: cohort.to_sym}
  end
  file.close
end

def process(selection)
  case selection
    when "1"
      @students = input_students
      @cohorts = get_cohorts
    when "2"
      show_students
    when "3"
      save_students
    when "4"
      try_load_students
    when "9"
      exit
    else
      puts "I don't know what you meant, try again"
  end
end

def interactive_menu
  loop do 
    print_menu
    process(STDIN.gets.chomp)
  end
end

interactive_menu

