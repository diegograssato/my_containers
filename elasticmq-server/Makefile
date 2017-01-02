
IMAGE_DEV="diegograssato/sqs-local"
IMAGE_PROD="diegograssato/elasticmq-server"
CONATAINER_DEV="sqs-local"

.PHONY: debug \
	release \
	clean

debug: clean \
	test
test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -p 9324:9324 \
                        --network=web_development \
						--ip=10.10.1.60 \
						-e PORT='9324' \
						-t $(IMAGE_DEV)

release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
