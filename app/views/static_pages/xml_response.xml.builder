xml = Builder::XmlMarkup.new
xml.instruct! :xml, version: '1.0'
  xml.Response(@xml)