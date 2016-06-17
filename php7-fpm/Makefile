
IMAGE_DEV="diegograssato/php7-fpm"
IMAGE_PROD="diegograssato/php7-fpm"
CONATAINER_DEV="php7-fpm"

.PHONY: debug \
	release \
	clean

debug: clean \
	test

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm \
						-p 5000:5000 \
						-p 9000:9000 \
						-t $(IMAGE_DEV)

release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
