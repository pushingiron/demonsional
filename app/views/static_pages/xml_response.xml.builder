xml = Builder::XmlMarkup.new
xml.instruct! :xml, version: '1.0'
xml.tag!('Wrap') do
  xml.Response(@xml)
end
p 'response'