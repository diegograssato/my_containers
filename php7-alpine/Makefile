
IMAGE_DEV="diegograssato/php7-alpine"
IMAGE_PROD="diegograssato/php7-alpine"
CONATAINER_DEV="php7-alpine"


.PHONY: debug \
	release \
	clean


debug: clean \
	test

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm \
                            -e PHP_XDEBUG_ENABLE="off" \
							-e PHP_XDEBUG_IDE_KEY="PHPSTORM" \
							-e PHP_XDEBUG_PROFILER_ENABLE="off" \
							-e PHP_XDEBUG_PROFILER_OUTPUT_DIR="/tmp/profile" \
							-e PHP_XDEBUG_PROFILER_OUTPUT_NAME="dtux.out.%p" \
							-e PHP_XDEBUG_REMOTE_LOG="/tmp/php-dtux.log" \
							-e PHP_XDEBUG_PORT="9000" \
							-e PHP_XDEBUG_REMOTE_IP="10.10.10.1" \
                            -e PHP_XDEBUG_REMOTE_LOG_ENABLE="on" \
                            -e PHP_PRODUCTION=false \
                            -e PHP_OPCACHE_ENABLE=false \
                            -e PHP_FPM_PORT=5000 \
                            -t $(IMAGE_DEV)
release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)
	docker build -t $(IMAGE_PROD):latest .
	docker push $(IMAGE_PROD):latest

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
