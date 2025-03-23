FROM ruby:3.4.2
WORKDIR /app
COPY . /app/
RUN bundle install
CMD ["ruby", "app.rb"]
