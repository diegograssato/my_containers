
IMAGE_DEV="diegograssato/nginx"
IMAGE_PROD="diegograssato/nginx"
CONATAINER_DEV="nginx"

.PHONY: debug \
	release \
	clean

debug: clean \
	test

debug2: clean \
	test_upstream

test:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm -p 80:80 -p 443:443 \
						-e NGINX_SITES_CUSTOM="/etc/nginx/sites-available/custom.conf /etc/nginx/sites-available/custom2.conf" \
						-t $(IMAGE_DEV)

test_upstream:
	docker build -t $(IMAGE_DEV) --rm .
	docker run --name $(CONATAINER_DEV) --rm \
							-p 80:80 -p 443:443 \
							--link="php7-fpm" \
							-v $(HOME)/open_solutions/web:/var/www \
							-e NGINX_DOCUMENT_ROOT="/var/www/" \
							-e VIRTUAL_HOST="{'name':'zf3','domains':['zf3'],'docroot':'zf3/public', 'ssl': 'false'}, \
															 {'name':'doito','domains':['dtux.drupal.com'],'docroot':'drupal-8', 'ssl': 'true'}, \
															 {'name':'api','domains':['api','api.dev'],'docroot':'apigility/public', 'ssl': 'true'}, \
														 	 {'name':'zf3-intermediario','domains':['zf3-intermediario'],'docroot':'zf3-intermediario/public', 'ssl': 'true'}, \
															 {'name':'laravel','domains':['laravel.dev','laravel'],'docroot':'laravel/public', 'ssl': 'true'}" \
							-e PHP_FPM_SOCKET="php7-fpm:5000" \
		          -e NGINX_WORKER_PROCESSES=4 \
		          -e NGINX_CONNECTIONS=20480 \
							-t $(IMAGE_DEV)


release:
	docker build -t $(IMAGE_PROD):$(shell cat VERSION) .
	docker push $(IMAGE_PROD):$(shell cat VERSION)

clean:
	docker stop $(CONATAINER_DEV) || true
	docker rm $(CONATAINER_DEV) || true
