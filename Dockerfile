FROM ruby:3.0.2-slim

RUN mkdir /jiraya
COPY . .
RUN chmod 777 -R ./src
RUN chmod 777 -R ./jiraya
RUN bundle install

ENTRYPOINT ["ruby", "/src/main.rb"]