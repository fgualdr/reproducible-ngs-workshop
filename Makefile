RUNTIME ?= docker
CLI_IMAGE ?= ubuntu:24.04
R_IMAGE ?= rocker/r-ver:4.4.2

.PHONY: help check render preview clean-rendered check-scripts check-links run-cli run-r test-container test-mount demo-rnaseq-small demo-chipseq-small

help:
	@printf 'Targets:\n'
	@printf '  check             Run lightweight validation\n'
	@printf '  render            Render Quarto site\n'
	@printf '  preview           Preview Quarto site\n'
	@printf '  clean-rendered    Remove rendered Quarto output\n'
	@printf '  check-scripts     Syntax-check shell scripts\n'
	@printf '  run-cli           Open CLI container\n'
	@printf '  run-r             Open R container\n'
	@printf '  test-container    Run a simple container command\n'
	@printf '  test-mount        Test host folder mount\n'

check:
	bash scripts_check_project.sh

render:
	quarto render

preview:
	quarto preview

clean-rendered:
	rm -rf docs

check-scripts:
	find scripts -name '*.sh' -print -exec bash -n {} \;

check-links:
	@printf 'Local link checking is handled partially by Quarto render.\n'

run-cli:
	$(RUNTIME) run --rm -it -v "$$PWD":/work -w /work $(CLI_IMAGE) bash

run-r:
	$(RUNTIME) run --rm -it -v "$$PWD":/work -w /work $(R_IMAGE) R

test-container:
	$(RUNTIME) run --rm $(CLI_IMAGE) echo container_ok

test-mount:
	bash scripts/day0/test_container_mount.sh $(RUNTIME)

demo-rnaseq-small:
	@printf 'Optional target: configure a reduced RNA-seq demo before running.\n'

demo-chipseq-small:
	@printf 'Optional target: configure a reduced ChIP-seq demo before running.\n'
