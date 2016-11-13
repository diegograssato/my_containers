
IMAGE_DEV="diegograssato/cli"
IMAGE_PROD="diegograssato/cli"
CONATAINER_DEV="cli"

.PHONY: debug \
	release \
	clean

debug: clean \
	test

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm \
				--network="config_default" \
				-e CLI_SYMFONY_DEV="FaLsE" \
				-e CLI_DRUSH="false" \
				-e CLI_DRUPAL_CLI="false" \
				-e CLI_CS="true" \
				-e CLI_SONAR="false" \
				-v $(HOME)/open_solutions/web:/var/www \
				-t $(IMAGE_DEV)

release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
