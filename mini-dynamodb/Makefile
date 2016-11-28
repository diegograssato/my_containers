
IMAGE_DEV="diegograssato/mini-dynamodb"
IMAGE_PROD="diegograssato/mini-dynamodb"
CONATAINER_DEV="mini-dynamodb"

.PHONY: debug \
	release \
	clean

debug: clean \
	test
test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -p 8088:8000 \
						-e PORT='8000' \
						-e SHARED='true' \
						-e MEMORY='false' \
						-t $(IMAGE_DEV)

release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
