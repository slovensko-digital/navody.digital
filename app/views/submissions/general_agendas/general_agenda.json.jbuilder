json.document do
  json.content Base64.encode64(@submission.content)
end

json.parameters do
  json.identifier @submission.identifier
  json.fileMimeType 'application/vnd.gov.sk.xmldatacontainer+xml'
  json.format 'XADES'
  json.container 'ASICE'
  json.containerFilename @submission.filename
  json.containerXmlns "http://data.gov.sk/def/container/xmldatacontainer+xml/1.1"
  json.schema @submission.schema
  json.transformation @submission.transformation
  json.transformationOutputMimeType 'text/plain'
end

json.payloadMimeType 'application/xml;base64'

# post 'signer://listen?protocol=http&host=localhost&port=37200&origin=*&language=sk'