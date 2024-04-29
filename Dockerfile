FROM ruby:3.3.0

# This script will failse with a probability of 1 in 10
CMD ["ruby", "-e", "puts('Handling: ' + (ENV['BATCH_TASK_INPUT'] || ''));sleep(5);(['true'].cycle(9).to_a + ['false']).sample ? puts('Successfully finished') : raise('Error')"]
