require 'cgi'
require 'google/apis/gmail_v1'
require 'mail'
require './config'

def handler(event:, context:)
  # event['path'] - e.g. /dev/send -> "/send" - e.g. part after /send/ - event['path'].split('/', 2)[1]
  path = event['pathParameters']['key']

  auth_config = GMAIL_CREDENTIALS[path]
  unless auth_config
    return { statusCode: 404, body: 'not found' }
  end

  params = (event['queryStringParameters'] || {}).merge(CGI.parse(event['body'] || '').transform_values(&:first))

  send_email(auth_config, to: params['to'], subject: params['subject'], body: params['body'])

  { statusCode: 200, body: 'ok' }
end


def send_email(auth_config, to:, subject:, body:)
  auth_client = Signet::OAuth2::Client.new(auth_config.merge(token_credential_uri: 'https://www.googleapis.com/oauth2/v4/token'))
  auth_client.refresh!
  service = Google::Apis::GmailV1::GmailService.new
  service.authorization = auth_client

  mail = Mail.new
  mail.to = to
  mail.subject = subject
  mail.body = body

  gmail_message = Google::Apis::GmailV1::Message.new(raw: mail.to_s, content_type: mail.content_type)
  service.send_user_message('me', gmail_message)
end
