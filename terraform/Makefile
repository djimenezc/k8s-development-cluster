SELF_DIR_TERRAFORM := $(dir $(lastword $(MAKEFILE_LIST)))
TERRAFORM_FOLDER ?= $(SELF_DIR_TERRAFORM)ec2-schedule-start-stop
TF_STATE_BUCKET_NAME ?= david-terraform-remote-state-${AWS_DEFAULT_REGION}
export KEY_NAME ?= terraform.tfstate
export TF_VAR_aws_region ?= ${AWS_DEFAULT_REGION}
export EXTRA_VARS =

terraform-create-workspace:
	cd $(TERRAFORM_FOLDER) && \
	terraform workspace select ${TF_VAR_aws_region} || terraform workspace new ${TF_VAR_aws_region}

terraform-delete-workspace:
	cd $(TERRAFORM_FOLDER) && \
	terraform workspace select default && terraform workspace delete ${TF_VAR_aws_region}

terraform-init:
	@echo "Current bucket: ${TF_STATE_BUCKET_NAME} region ${AWS_DEFAULT_REGION}"
	cd $(TERRAFORM_FOLDER) && \
	terraform init -backend-config=bucket=${TF_STATE_BUCKET_NAME} -backend=true -reconfigure -backend-config=key=${KEY_NAME}

terraform-validate:
	cd $(TERRAFORM_FOLDER) && \
	terraform fmt -check -recursive -diff && \
	terraform validate

terraform-format:
	cd $(TERRAFORM_FOLDER) && \
	terraform fmt -recursive

terraform-plan: terraform-create-workspace terraform-plan-action
	cd $(TERRAFORM_FOLDER) && \
	terraform plan ${EXTRA_VARS}

terraform-apply: terraform-create-workspace
	cd $(TERRAFORM_FOLDER) && \
	terraform apply -auto-approve ${EXTRA_VARS}

terraform-plan-destroy: terraform-create-workspace
	cd $(TERRAFORM_FOLDER) && \
	terraform plan -destroy ${EXTRA_VARS}

terraform-destroy-resources: terraform-create-workspace
	cd $(TERRAFORM_FOLDER) && \
	terraform destroy -auto-approve ${EXTRA_VARS}

terraform-destroy: terraform-destroy-resources terraform-delete-workspace

terraform-output: terraform-create-workspace
	cd $(TERRAFORM_FOLDER) && \
	terraform output

# Custom function to run action before performing the terraform plan
# This is useful to run commands against the Terraform API
# (e.g.adding existing resources or removing a resource from being managed by Terraform).
# Unless overriden, this target does nothing

terraform-plan-action:
	$(call terraform-plan-action)

define terraform-plan-action
endef
