#####################################################
# Makefile containing shortcut commands for project #
#####################################################

# MACOS USERS:
#  Make should be installed with XCode dev tools.
#  If not, run `xcode-select --install` in Terminal to install.

# WINDOWS USERS:
#  1. Install Chocolately package manager: https://chocolatey.org/
#  2. Open Command Prompt in administrator mode
#  3. Run `choco install make`
#  4. Restart all Git Bash/Terminal windows.

.PHONY: docker-clean docker-down docker-force docker-logs docker-start docker-stop docker-up

docker-clean:
	docker-compose down --rmi all --volumes

docker-down:
	docker-compose down --remove-orphans

docker-force:
	docker-compose up --force-recreate

docker-logs:
	docker-compose logs -f

docker-start:
	docker-compose start

docker-stop:
	docker-compose stop

docker-up:
	docker-compose up

.PHONY: tf-init tf-fmt tf-validate tf-plan tf-apply tf-destroy tf-workspace-list tf-workspace-dev tf-workspace-staging tf-workspace-prod

tf-init:
	docker-compose run --rm terraform init

tf-fmt:
	docker-compose run --rm terraform fmt

tf-validate:
	docker-compose run --rm terraform validate

tf-plan:
	docker-compose run --rm terraform plan

tf-apply:
	docker-compose run --rm terraform apply

tf-destroy:
	docker-compose run --rm terraform destroy

tf-workspace-list:
	docker-compose run --rm terraform workspace list

tf-workspace-dev:
	docker-compose run --rm terraform workspace select dev

tf-workspace-staging:
	docker-compose run --rm terraform workspace select staging

tf-workspace-prod:
	docker-compose run --rm terraform workspace select prod
