.DEFAULT_GOAL := all

combine:
	cat deploy/*.yml > deploy/all-in-one.yml
clean:
	rm deploy/all-in-one.yml || true

all: clean | combine
