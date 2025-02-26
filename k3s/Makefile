
install-k3s:
	# if flennel none might need other network fabric 
	# curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644"  sh -s - --flannel-backend=none
	curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644"  sh -s -
	sudo cp registries.yaml /etc/rancher/k3s/
	# Install flannel network fabric
	# sudo kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
	# Install metallb Bere metal load-balancer
	# sudo kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
	# sudo kubectl apply -f metallb-config.yaml
	# sudo systemctl restart k3s

uninstall-k3s:
	sudo bash /usr/local/bin/k3s-uninstall.sh	

apply-setting:
	kubectl apply -f statefulset.yaml
	kubectl apply -f headless.yaml

kill-allpods:
	kubectl delete statefulset lab-pod
	kubectl delete pvc -l app=lab-env
	kubectl delete pod -l app=lab-env
	kubectl delete svc -l app=lab-env
	kubectl get pods,svc -l app=lab-env -o wide
# Install registry on localmachine 
run-registry:
	sudo docker run -d -p 5000:5000 --restart always --name registry registry:2

show-allports:
	kubectl get svc -o wide
	
get-nodes:
	sudo kubectl get nodes 
