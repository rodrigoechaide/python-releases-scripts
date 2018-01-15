
help:
	@echo "Rules:"
	@echo " * test: Executes e2e tests. Require local instance running"
	@echo " * rfhub: Starts test steps help server"
	@echo ""

test:
	robot --outputdir results tests

rfhub:
	rwt robotframework-hub -- -m rfhub tests

requirements:
	pip install -r requirements.txt


