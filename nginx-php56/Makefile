
IMAGE_DEV="diegograssato/nginx-php56"
IMAGE_PROD="diegograssato/nginx-php56"
CONATAINER_DEV="nginx-php56"

.PHONY: debug \
	release \
	clean

debug: clean \
	test

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -p 81:80 \
        --network="web_development" -v $(HOME)/open_solutions/web:/var/www/html -t $(IMAGE_DEV) 


release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
