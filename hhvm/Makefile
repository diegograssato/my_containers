
IMAGE_DEV="diegograssato/hhvm"
IMAGE_PROD="diegograssato/hhvm"
CONATAINER_DEV="hhvm"

.PHONY: debug \
	release \
	clean

debug: clean \
	test

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm \
						-p 9001:9000 \
						-v $(HOME)/open_solutions/web:/var/www \
						-t $(IMAGE_DEV)

release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
