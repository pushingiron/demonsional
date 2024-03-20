module MercuryGateService
  require 'rexml/document'
  include REXML
  include MercuryGateXml
  include MercuryGateJson
  include Base64

  WS_URL_PROTOCOL = 'https://'.freeze
  WS_URL_URL = '.mercurygate.net/MercuryGate/common/remoteService.jsp'.freeze




end
