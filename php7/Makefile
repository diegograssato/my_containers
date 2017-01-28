
IMAGE_DEV="diegograssato/php7"
IMAGE_PROD="diegograssato/php7"
CONATAINER_DEV="php7"

IMAGE_DEV70="diegograssato/php7:7.0"
CONATAINER_DEV70="php70"
IMAGE_PROD70="diegograssato/php7:7.0"

.PHONY: debug \
	release \
	clean \
	clean70 \
	debug70 \
	release70


debug: clean \
	test

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm \
							-p 5000:5000 \
							-e PHP_FPM_ENABLED='true' \
							-e PHP_ENABLE_MOD='xdebug' \
							-e PHP_DIS_MOD='mongodb' \
							-t $(IMAGE_DEV)
release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)
	docker build -t $(IMAGE_PROD):latest .
	docker push $(IMAGE_PROD):latest


debug70: clean70 \
	test70

test70:
	docker build -f Dockerfile.70 -t $(IMAGE_DEV70) --rm .
	docker run --name $(CONATAINER_DEV70) --rm \
							-p 5001:5000 \
							-e PHP_FPM_ENABLED='true' \
							-e PHP_ENABLE_MOD='xdebug' \
							-e PHP_DIS_MOD='mongodb' \
							-t $(IMAGE_DEV70)
release70:
	docker build -f Dockerfile.70 -t $(IMAGE_PROD70) .
	docker push $(IMAGE_PROD70)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true

clean70:
	docker stop $(CONATAINER_DEV70) || true
	docker rm $(CONATAINER_DEV70) || true
