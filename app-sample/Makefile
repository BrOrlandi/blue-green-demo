server = ec2-user@devpira.brorlandi.xyz
project_path = $(shell basename $(shell pwd))

rsync:
	rsync -azv . $(server):$(project_path) --exclude .git --exclude-from .gitignore

deploy: rsync
	ssh $(server) "cd $(project_path) && docker compose down && docker compose up -d --build"

deploy-bg: rsync
	ssh $(server) "cd $(project_path) && sh ./deploy.sh"

down:
	ssh $(server) "cd $(project_path) && docker compose --project-name=app-sample-blue down && docker compose --project-name=app-sample-green down"

