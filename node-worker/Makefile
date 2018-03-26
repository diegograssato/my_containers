
IMAGE_DEV="diegograssato/node-worker"
IMAGE_PROD="diegograssato/node-worker"
CONATAINER_DEV="node-worker"


.PHONY: debug \
	release \
	clean

debug: clean \
	test

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm  \
                            -t $(IMAGE_DEV) \
							bash -c "ps ax && whoami"
release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)
	docker build -t $(IMAGE_PROD):latest .
	docker push $(IMAGE_PROD):latest

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
