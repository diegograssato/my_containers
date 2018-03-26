
IMAGE_DEV="diegograssato/radiusd"
IMAGE_PROD="diegograssato/radiusd"
CONATAINER_DEV="radiusd"

.PHONY: debug \
	release \
	clean

debug: clean \
	test 

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -p 1812:1812 -p 1813:1813 -p 1814:1814 -p 18120:18120 \
	 					-t $(IMAGE_DEV)
 

release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
