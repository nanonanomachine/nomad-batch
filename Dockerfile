FROM --platform=linux/amd64 ruby:3.3.0

# Take input arg and echo for testing purpose
ARG input
RUN echo $input

# This script will failse with a probability of 1 in 10
RUN ["ruby", "-e", "sleep(5);(['true'].cycle(9).to_a + ['false']).sample ? puts('Successfully finished') : raise('Error')"]
