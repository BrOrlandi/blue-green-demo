server = ec2-user@bluegreen.duckdns.org
project_path = $(shell basename $(shell pwd))

rsync:
	rsync -azv . $(server):$(project_path)

deploy: rsync
	ssh $(server) "cd $(project_path) && docker compose down && docker compose up -d --build"

deploy-bg: rsync
	ssh $(server) "cd $(project_path) && sh ./deploy.sh"

down:
	ssh $(server) "cd $(project_path) && docker compose down"

