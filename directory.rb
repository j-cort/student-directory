@students = []
@cohorts = []

# **** COLLECT STUDENT INFO ****
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
      add_student(students, name, cohort, weapon)
    end
  end
  # assign array to @students instance variable
  @students = students
end

def add_student(destination, name, cohort, weapon)
  cohort = cohort.to_sym
  weapon = weapon.to_sym
  destination << {name: name, cohort: cohort, weapon: weapon}
end

def get_cohorts
  @students.map { |student| student[:cohort]}.uniq
end

# **** DISPLAY STUDENT INFO ****
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

def print_by_cohort
  @cohorts.each do |cohort|
    puts "#{cohort.to_s.upcase} COHORT".center(100)
    @students.each_with_index do |student, index|
      if student[:cohort] == cohort
        puts "#{student[:name]}, #{student[:weapon]} user".center(100)
      end
    end
    puts "\n"
  end
end

# **** SAVE STUDENT INFO ****
def save_students
  # get filename
  puts "Enter filename e.g. 'psychos.csv'"
  filename = STDIN.gets.chomp
  # open the file for writing
  file = File.open(filename, "w")
  # iterate over the array of students
  @students.each do |student|
    student_data = [student[:name], student[:cohort], student[:weapon]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  # close file and report status
  file.close
  puts "Saved #{@students.count} to #{filename}"
end

# **** LOAD STUDENT INFO ****
def load_menu
    print_load_menu
    load_options(STDIN.gets.chomp)
end

def print_load_menu
  puts "1. Load preloaded file"
  puts "2. Load new file"
  puts "3. Back to main menu"
end

def load_options(selection)
  case selection
    when "3"
      puts "**Back To Main Menu Selected...**"
      return
    when "1"
      puts "**Load Preloaded File Selected...**"
      # load preloaded file if there is one, else load a default file
      filename = ARGV.first
      load_process(filename, nil, "No file was preloaded at launch")
    when "2"
      # load new file if valid filename is provided, else load a default file
      puts "**Load New File Selected...**"
      puts "Enter filename e.g. 'psychos.csv'"
      filename = STDIN.gets.chomp
      load_process(filename, "", "No filename entered")
    else
      puts "I don't know what you meant, back to main menu"
  end
end

def load_process(filename, no_file, message)
  if filename == no_file
    puts message
    load_students
    puts "loaded #{@students.count} from students.csv by default"
  elsif File.exists?(filename)
    load_students(filename)
    puts "loaded #{@students.count} from #{filename}"
  else
    puts "Sorry, #{filename} doesn't exist"
    load_students
    puts "loaded #{@students.count} from students.csv by default"
  end
end

def load_students(filename = "students.csv")
  students = []
  file = File.open(filename, "r")
  file.readlines.each do |line|
    name, cohort, weapon = line.chomp.split(",")
    add_student(students, name, cohort, weapon)
  end
  file.close
  @students = students
  @cohorts = get_cohorts
end

# NAVIGATE PROGRAM
def interactive_menu
  loop do 
    print_menu
    menu_options(STDIN.gets.chomp)
  end
end

def print_menu
  puts "1. Input students"
  puts "2. Show students"
  puts "3. Save student list to file"
  puts "4. Load student list from file"
  puts "9. Exit"
end

def menu_options(selection)
  case selection
    when "1"
      puts "**Input Students Selected...**"
      @students = input_students
      @cohorts = get_cohorts
    when "2"
      puts "**Show Students Selected...**"
      show_students
    when "3"
      puts "**Save Students Selected...**"
      save_students
    when "4"
      puts "**Load Students Selected...**"
      load_menu
    when "9"
      puts "**Exit Program Selected...**"
      exit
    else
      puts "I don't know what you meant, try again"
  end
end

interactive_menu

