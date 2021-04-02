Given(/^I am on the home page$/) do
  visit '/static_pages/index'
end

Then(/^I should see "(.*?)"$/) do |text|
  page.has_content?(text)
end