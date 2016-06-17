
IMAGE_DEV="diegograssato/ngnix"
IMAGE_PROD="diegograssato/ngnix"
CONATAINER_DEV="ngnix"

.PHONY: debug \
	release \
	clean

debug: clean \
	test

debug2: clean \
	test_upstream

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -p 80:80 -p 443:443 \
						-t $(IMAGE_DEV)

test_upstream:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -p 80:80 -p 443:443 \
							--link="php7-fpm" \
							-e DOCUMENT_ROOT="/var/www/default" \
		          -e APP_SERVER_NAME="symfony.dev" \
		          -e APP_INDEX_FILE="index.php" \
		          -e PHP_FPM_SOCKET="php7-fpm:5000" \
		          -e NGINX_WORKER_PROCESSES=4 \
		          -e NGINX_CONNECTIONS=20480 \
							-t $(IMAGE_DEV)


release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
