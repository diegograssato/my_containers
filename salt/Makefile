
IMAGE_DEV="diegograssato/salt"
IMAGE_PROD="diegograssato/salt"
CONATAINER_DEV="salt"

.PHONY: debug \
	release \
	clean

debug: clean \
	test 

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -p 8080:8080 -p 8081:8081 \
	-v $(PWD)/srv/salt:/srv/salt/ \
	-e  SALT_USE="master"  \
	-e  SALT_NAME="master" \
	-e  SALT_GRAINS="{'test': 'test'}" \
	-e  LOG_LEVEL"debug" \
	-t $(IMAGE_DEV)

release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
