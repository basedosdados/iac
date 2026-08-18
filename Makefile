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

.PHONY: create-dev update-dev

create-dev:
	python3 -m venv .venv; \
	. .venv/bin/activate; \
	pip install --upgrade poetry; \
	poetry install; \
	pre-commit install;

update-dev:
	. .venv/bin/activate; \
	poetry update;

.PHONY: fetch-sealing-cert lint-secrets seal-secret seal-value

# Python entrypoint for utils/main.py. Uses the project venv when its
# dependencies are actually installed (`make create-dev`), otherwise falls back
# to uv, which resolves typer on the fly. Probing for the venv directory is not
# enough -- an empty .venv is a common leftover.
UTILS := $(shell .venv/bin/python -c "import typer" 2>/dev/null \
	&& echo ".venv/bin/python utils/main.py" \
	|| echo "uv run --quiet --with typer python utils/main.py")

# Fetch the sealed-secrets public certificate once, so later sealing needs no
# cluster access. Requires a live `gcloud auth login`.
fetch-sealing-cert:
	$(UTILS) fetch-sealing-cert

# Report which snapshot is live per Secret, and fail on structural mistakes.
lint-secrets:
	$(UTILS) lint-secrets

# Create a new SealedSecret. The namespace is read from the directory's
# namespace.yaml; the file lands in the next free secret-NN slot.
#   make seal-secret DIR=k8s/prefect_workers/basedosdados NAME=api-keys ENVFILE=/tmp/keys.env
seal-secret:
	@test -n "$(DIR)" || (echo "set DIR=<namespace directory under k8s/>" && exit 1)
	@test -n "$(NAME)" || (echo "set NAME=<metadata.name of the Secret>" && exit 1)
	@test -n "$(ENVFILE)" || (echo "set ENVFILE=<file of KEY=VALUE lines>" && exit 1)
	$(UTILS) seal-secret --directory $(DIR) --name $(NAME) --from-env-file $(ENVFILE) \
		$(if $(INDEX),--index $(INDEX),)

# Add or rotate a single key inside an existing SealedSecret, without needing
# the plaintext of the other keys. Prefer VALUEFILE= over VALUE= -- the latter
# lands in shell history.
#   make seal-value FILE=... NAME=api-keys NAMESPACE=... KEY=FRED_API_KEY VALUEFILE=/tmp/fred
seal-value:
	@test -n "$(FILE)" || (echo "set FILE=<path to the sealed manifest>" && exit 1)
	@test -n "$(NAME)" || (echo "set NAME=<metadata.name of the Secret>" && exit 1)
	@test -n "$(NAMESPACE)" || (echo "set NAMESPACE=<target namespace>" && exit 1)
	@test -n "$(KEY)" || (echo "set KEY=<key to add or replace>" && exit 1)
	$(UTILS) seal-value --into $(FILE) --name $(NAME) --namespace $(NAMESPACE) --key $(KEY) \
		$(if $(VALUEFILE),--value-file $(VALUEFILE),--value '$(VALUE)')

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

.PHONY: tf-apply tf-check tf-destroy tf-fmt tf-init tf-init-ms tf-init-r tf-init-u tf-plan tf-state tf-validate tf-workspace-list tf-workspace-production tf-workspace-staging

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

tf-init-u:
	docker-compose run --rm bd_terraform init -upgrade

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
