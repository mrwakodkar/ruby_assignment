require 'minitest/autorun'
require_relative 'questionnaire'

class QuestionnaireTest < Minitest::Test
  def setup
    File.delete(STORE_NAME) if File.exist?(STORE_NAME)
  end

  def test_is_valid_answer?
    assert is_valid_answer?('y')
    assert is_valid_answer?('yes')
    assert is_valid_answer?('n')
    assert is_valid_answer?('no')
    refute is_valid_answer?('maybe')
    refute is_valid_answer?('42')
  end

  def test_calculate_rating
    answers = {
      'q1' => true,
      'q2' => false,
      'q3' => true,
      'q4' => false,
      'q5' => true
    }
    assert_equal 60.0, calculate_rating(answers)
  end

  def test_do_prompt
    simulated_input = "y\nn\ny\nn\ny\n"
    captured_output = capture_output do
      simulate_input(simulated_input) do
        do_prompt
      end
    end

    assert_match 'Rating for this run: 60.0%', captured_output
  end

  def test_do_report
    store = PStore.new(STORE_NAME)
    store.transaction do
      store[:ratings] = [60.0, 80.0, 100.0]
    end

    captured_output = capture_output do
      do_report
    end

    assert_match 'Average rating across all runs: 80.0%', captured_output
  end

  private

  def simulate_input(input)
    $stdin = StringIO.new(input)
    yield
  ensure
    $stdin = STDIN
  end

  def capture_output
    captured_output = StringIO.new
    original_stdout = $stdout
    $stdout = captured_output
    yield
    captured_output.string
  ensure
    $stdout = original_stdout
  end
end
