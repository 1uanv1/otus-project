bootstrap:
	bash scripts/bootstrap.sh

deploy:
	kubectl apply -f k8s/
