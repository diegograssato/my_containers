
IMAGE_DEV="diegograssato/sns-local"
IMAGE_PROD="diegograssato/elasticsns-server"
CONATAINER_DEV="sns-local"

.PHONY: debug \
	release \
	clean

debug: clean \
	test
test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -p 9911:9911 \
						-e HTTP_INTERFACE="0.0.0.0" \
            -e HTTP_PORT="9911" \
						-t $(IMAGE_DEV)

release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
