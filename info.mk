YELLOW := "\e[1;33m"
RESET := "\e[0m"

INFO := @bash -c '\
	printf $(YELLOW); \
	echo "=> $$1"; \
	printf $(RESET)' BLANK
