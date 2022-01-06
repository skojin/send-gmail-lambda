# send-gmail-lambda

Small simple AWS lambda REST microservice that send email via Gmail

## Setup

```
git clone https://github.com/skojin/send-gmail-lambda.git
cd send-gmail-lambda
npm install
bundle install
cp config.rb.example config.rb
```

Get gmail oauth credential using [this guide](https://medium.com/wesionary-team/sending-emails-with-go-golang-using-smtp-gmail-and-oauth2-185ee12ab306), and save them to config.rb

Deploy to AWS lambda with [Serverless Framework](https://www.serverless.com/framework/docs/getting-started)

```
serverless deploy
```

Remember endpoint URL from deploy command output

## Invoke

```ruby
  # ruby
  Net::HTTP.post_form(
    URI("https://XXX.execute-api.us-east-1.amazonaws.com/dev/send/some-random-secure-key"),
    {to: "email@example.com", subject: 'SUBJECT' body: 'TEXT BODY'})
```

```
curl -X POST "https://XXX.execute-api.us-east-1.amazonaws.com/dev/send/some-random-secure-key" -d "subject=SUBJECT&body=BODY&to=email@example.com"
```
