.PHONY: test

deploy:
	serverless deploy

logs-tail:
	serverless logs -f hello -t

