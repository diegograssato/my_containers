
IMAGE_DEV="diegograssato/php56"
IMAGE_PROD="diegograssato/php56"
CONATAINER_DEV="php56"

.PHONY: debug \
	release \
	clean

debug: clean \
	test

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -t $(IMAGE_DEV)

release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
#	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
