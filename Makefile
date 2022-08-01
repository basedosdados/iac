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

.PHONY: tf-init tf-fmt tf-validate tf-plan tf-apply tf-destroy tf-workspace-list tf-workspace-staging tf-workspace-production

tf-init:
	docker-compose run --rm bd_terraform init

tf-fmt:
	docker-compose run --rm bd_terraform fmt --recursive

tf-validate:
	docker-compose run --rm bd_terraform validate

tf-plan:
	docker-compose run --rm bd_terraform plan

tf-apply:
	docker-compose run --rm bd_terraform apply

tf-destroy:
	docker-compose run --rm bd_terraform destroy

tf-workspace-list:
	docker-compose run --rm bd_terraform workspace list

tf-workspace-staging:
	docker-compose run --rm bd_terraform workspace select staging

tf-workspace-production:
	docker-compose run --rm bd_terraform workspace select production
