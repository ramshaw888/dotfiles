build:
	docker build -t dotfiles .

.PHONY: default
default: build;
