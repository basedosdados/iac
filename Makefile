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

.PHONY: tf-apply tf-check tf-destroy tf-fmt tf-init tf-init-ms tf-init-r tf-plan tf-state tf-validate tf-workspace-list tf-workspace-production tf-workspace-staging

tf-apply:
	docker-compose run --rm bd_terraform apply

tf-apply-ro:
	docker-compose run --rm bd_terraform apply -refresh-only

tf-check:
	docker-compose run --rm bd_terraform fmt -check

tf-destroy:
	docker-compose run --rm bd_terraform destroy

tf-fmt:
	docker-compose run --rm bd_terraform fmt --recursive

tf-init:
	docker-compose run --rm bd_terraform init

tf-init-ms:
	docker-compose run --rm bd_terraform init -migrate-state

tf-init-r:
	docker-compose run --rm bd_terraform init -reconfigure

tf-plan:
	docker-compose run --rm bd_terraform plan

tf-state:
	docker-compose run --rm bd_terraform state list

tf-validate:
	docker-compose run --rm bd_terraform validate

tf-workspace-list:
	docker-compose run --rm bd_terraform workspace list

tf-workspace-production:
	docker-compose run --rm bd_terraform workspace select production

tf-workspace-staging:
	docker-compose run --rm bd_terraform workspace select staging
