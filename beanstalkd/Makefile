
IMAGE_DEV="diegograssato/beanstalkd-local"
IMAGE_PROD="diegograssato/beanstalkd-server"
CONATAINER_DEV="beanstalkd-local"

.PHONY: debug \
	release \
	clean

debug: clean \
	test
test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -p 11300:11300 \
                        --network=web_development \
						--ip=10.10.1.80 \
						-t $(IMAGE_DEV)

release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
