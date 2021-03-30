Given(/^I am on the home page$/) do
  visit '/greetings/hello'
end

Then(/^I should see "(.*?)"$/) do |text|
  page.has_content?(text)
end