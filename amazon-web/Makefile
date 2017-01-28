
IMAGE_DEV="diegograssato/amazon-web"
IMAGE_PROD="diegograssato/amazon-web"
CONATAINER_DEV="amazon-web"

.PHONY: debug \
	release \
	clean


debug: clean \
	test

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm \
                            -p 812:80 \
                            -e PHP_XDEBUG_ENABLE="on" \
							-e PHP_XDEBUG_IDE_KEY="PHPSTORM" \
							-e PHP_XDEBUG_PROFILER_ENABLE="on" \
							-e PHP_XDEBUG_PROFILER_OUTPUT_DIR="/tmp/profile" \
							-e PHP_XDEBUG_PROFILER_OUTPUT_NAME="dtux.out.%p" \
							-e PHP_XDEBUG_REMOTE_LOG="/tmp/php-dtux.log" \
							-e PHP_XDEBUG_PORT="9000" \
							-e PHP_XDEBUG_REMOTE_IP="10.10.0.1" \
                            -e PHP_PRODUCTION="off" \
                            -v "/home/diego/projects/sgna/angular:/var/www/angular" \
                            -v "/home/diego/projects/sgna/symfony:/var/www/symfony" \
                            -t $(IMAGE_DEV)
release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)
	docker build -t $(IMAGE_PROD):latest .
	docker push $(IMAGE_PROD):latest

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
