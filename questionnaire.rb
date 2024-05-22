require "pstore"

STORE_NAME = "tendable.pstore".freeze

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

LIST_VALID_YES_ANSWERS = %w[y yes].freeze
LIST_VALID_NO_ANSWERS = %w[n no].freeze


def prompt_user_for_answers_to_calculate_rating
  answers = {}
  QUESTIONS.each do |question_key, question|
    answer = nil
    loop do
      print "#{question} (Y/N/Yes/No): "
      answer = gets.chomp.downcase
      break if is_valid_answer?(answer)
      puts 'Invalid answer. Please enter "Yes", "No", "Y", or "N"'
    end
    answers[question_key] = LIST_VALID_YES_ANSWERS.include?(answer)
  end
  answers
end

#checks if the given answers is valid or not
def is_valid_answer?(answer)
  LIST_VALID_YES_ANSWERS.include?(answer) || LIST_VALID_NO_ANSWERS.include?(answer)
end

#caculate the ratings as per given formula
def calculate_rating(answers)
  yes_answers = answers.values.count(true)
  (100.0 * yes_answers / QUESTIONS.size).round(2)
end

def do_prompt
  store = PStore.new(STORE_NAME)
  answers = prompt_user_for_answers_to_calculate_rating

  rating = calculate_rating(answers)
  puts "Rating for this run: #{rating}%"

  store.transaction do
    #Initialize the answers with empty array if its not already present in the store
    store[:answers] ||= []
    #appends the answers hash to the store[:answers] array.
    store[:answers] << answers

    #Initialize the ratings with empty array if its not already present in the store
    store[:ratings] ||= []
    #appends the answers hash to the store[:ratings] array.
    store[:ratings] << rating
  end
end

def do_report
  store = PStore.new(STORE_NAME)
  store.transaction(true) do
    ratings = store[:ratings] || []
    if ratings.empty?
      puts "No data available"
    else
      avg_rating = (ratings.sum / ratings.size.to_f).round(2)
      puts "Average rating across all runs: #{avg_rating}%"
    end
  end
end

do_prompt
do_report
