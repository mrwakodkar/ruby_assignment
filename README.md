# Tendable Coding Assessment

## Usage

```sh
bundle install
ruby questionnaire.rb
```

## Goal

The goal is to implement a survey where a user should be able to answer a series of Yes/No questions. After each run, a rating is calculated to let them know how they did. Another rating is also calculated to provide an overall score for all runs.

## Requirements

Possible question answers are: "Yes", "No", "Y", or "N" case insensitively to answer each question prompt.

The answers will need to be **persisted** so they can be used in calculations for subsequent runs >> it is proposed you use the pstore for this, already included in the Gemfile

After _each_ run the program should calculate and print a rating. The calculation for the rating is: `100 * number of yes answers / number of questions`.

The program should also print an average rating for all runs.

The questions can be found in questionnaire.rb

Ensure we can run your exercise

## Bonus Points

Updated readme with an explanation of your approach

Unit Tests

Code Comments

Dockerfile / Bash script if needed for us to run the exercise


## Approach

This program is a survey system where the user is asked a series of questions, and a rating is calculated based on their answers. The rating for each run is printed, and the average rating across all runs is also printed.
In this program, we use PStore, which is a persistent Ruby hash store. It helps us store the user's answers and ratings so that we can use them later.
The program follows these steps:

-First, the ```prompt_user_for_answers_to_calculate_rating``` method asks the user a set of questions from the ```QUESTIONS``` hash, and their answers are stored in a new hash. The ```is_valid_answer?``` method is used to validate the user's input.

-Then, the ```calculate_rating``` method calculates a rating from the user's answers hash based on a formula.

-The ```do_prompt``` method informs the user of their rating for the current run and stores the user's answers and rating in the PStore using the ```store[:answers]``` and ```store[:ratings]``` keys, respectively.

-Finally, the ```do_report``` method retrieves the stored ratings from the PStore and calculates the average rating across all runs, printing it to the console.

In this program, the user can only answer with "Yes", "No", "Y", or "N". If the user provides any other answer, the program informs them that their answer is invalid and prompts them to answer again using the is_valid_answer? method.
This program is straightforward, but it uses PStore to persist the user's data so that we can use it later.

