Given(/^I am on the home page$/) do
  visit '/homes/index'
end

Then(/^I should see "(.*?)"$/) do |text|
  page.has_content?(text)
end