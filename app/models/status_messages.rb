class StatusMessages < ActiveRecord::Base

  include REXML

  attribute :id, :integer


  def self.import(user, file)
    begin
      p file_path = file.path
    rescue StandardError
      p file = open(Rails.root.join('app', 'assets', 'data', 'SO Automation.csv'))
      p file_path = file.path
    end
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      p  spreadsheet.row(i)
      unless spreadsheet.row(i)[16].blank?
        @response = MercuryGateApiServices.mg_post_xml(user, xml_status_kp_ocean(user, spreadsheet.row(i)))
        @response = MercuryGateApiServices.mg_post_xml(user, xml_status_kp_port(user, spreadsheet.row(i)))
      end

    end
  end

  private


  def self.xml_status_kp_ocean(user, data)
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = ::Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'ImportWeb'
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.tag! 'WebImport' do
          xml.tag! 'WebImportHeader' do
            xml.FileName "STATUS-#{request_id}.xml"
            xml.Type 'WebImportStatusContainer'
            xml.UserName Profile.ws_user_id(user)
          end
          xml.tag! 'WebImportFile'do
            xml.tag! 'MercuryGate' do
              xml.tag! 'Header' do
                xml.SenderID 'MGSALES'
                xml.ReceiverID 'MGSALES'
                xml.OriginalFileName "ENT#{request_id}.xml"
                xml.Action 'Add'
                xml.DocTypeID 'Status'
              end
              xml.Status shipmentId: data[0], proNumber: data[0], carrierSCAC: data[14] do
                xml.ReferenceNumbers do
                  xml.ReferenceNumber data[0], type: 'Container Number'
                end
                xml.Locations do
                  xml.Location addr1: '2 Main St', addr2: '', city: 'Garden City',
                               countryCode: 'US', postalCode: '31408',
                               state: 'GA', type: 'Seaport'
                end
                xml.StatusDetails do
                  xml.StatusDetail address: '2 Main St', apptCode: '', apptReasonCode: '',
                                   cityName: 'Garden City', countryCode: 'US',
                                   date: (DateTime.strptime(data[16], '%m/%d/%y %H:%M')).strftime('%Y%m%d'),
                                   equipNum: '', equipNumCheckDigit: '', equipDescCode: '', index: '', podName: '',
                                   scacCode: '', stateCode: 'GA', statusCode: 'AG',
                                   statusReasonCode: '', stopNum: '', time: '0800'
                end
              end
            end
          end
        end
      end
    end
    p xml.target!
  end

  def self.xml_status_kp_port(user, data)
    request_id = Time.now.strftime('%Y%m%d%H%M%L')
    xml = ::Builder::XmlMarkup.new
    xml.instruct! :xml, version: '1.0'
    xml.tag! 'service-request' do
      xml.tag! 'service-id', 'ImportWeb'
      xml.tag! 'request-id', request_id
      xml.tag! 'data' do
        xml.tag! 'WebImport' do
          xml.tag! 'WebImportHeader' do
            xml.FileName "STATUS-#{request_id}.xml"
            xml.Type 'WebImportStatusContainer'
            xml.UserName Profile.ws_user_id(user)
          end
          xml.tag! 'WebImportFile'do
            xml.tag! 'MercuryGate' do
              xml.tag! 'Header' do
                xml.SenderID 'MGSALES'
                xml.ReceiverID 'MGSALES'
                xml.OriginalFileName "ENT#{request_id}.xml"
                xml.Action 'Add'
                xml.DocTypeID 'Status'
              end
              xml.Status shipmentId: data[0], proNumber: data[0], carrierSCAC: 'NADR' do
                xml.ReferenceNumbers do
                  xml.ReferenceNumber data[0], type: 'Container Number'
                end
                xml.Locations do
                  xml.Location addr1: '2 Main St', addr2: '', city: 'Garden City',
                               countryCode: 'US', postalCode: '31408',
                               state: 'GA', type: 'Seaport'
                end
                xml.StatusDetails do
                  xml.StatusDetail address: '2 Main St', apptCode: '', apptReasonCode: '',
                                   cityName: 'Garden City', countryCode: 'US',
                                   date: (DateTime.strptime(data[16], '%m/%d/%y %H:%M')).strftime('%Y%m%d'),
                                   equipNum: '', equipNumCheckDigit: '', equipDescCode: '', index: '', podName: '',
                                   scacCode: 'NADR', stateCode: 'GA', statusCode: 'AA',
                                   statusReasonCode: '', stopNum: '', time: '0800'
                end
              end
            end
          end
        end
      end
    end
    p xml.target!
  end

  def self.date_format(date)
    DateTime.strptime(date, '%m/%d/%Y %I:%M%p')
  end

  def self.open_spreadsheet(file)
    p File.extname(file)
    case File.extname(file)
    when '.csv' then Roo::CSV.new(file.path)
    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
