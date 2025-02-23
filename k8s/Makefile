
install-k3s:
	curl -sfL https://get.k3s.io | sh -

# Install registry on localmachine 
run-registry:
	sudo docker run -d -p 5000:5000 --restart always --name registry registry:2
