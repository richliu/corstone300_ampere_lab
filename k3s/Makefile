

help:
	@echo "make [OPTION]"
	@echo ""
	@echo "[OPTIONS]"
	@echo "    install-k3s: Install k3s into system"
	@echo "    uninstall-k3s: Uninstall k3s into system"
	@echo "    create-lab: create lab environment"
	@echo "    kill-allpods: kill all lab environment"
	@echo "    show-allpods: show currnet lab export ports"
	@echo "    apply-setting: Apply new setting"


install-k3s:
	curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644"  sh -s -
	sudo cp registries.yaml /etc/rancher/k3s/
	sudo systemctl restart k3s

uninstall-k3s:
	sudo bash /usr/local/bin/k3s-uninstall.sh	

apply-setting:
	kubectl apply -f statefulset.yaml
	kubectl apply -f headless.yaml

create-lab:
	sudo bash create-account.sh

kill-allpods:
	kubectl delete statefulset lab-pod
	kubectl delete pvc -l app=lab-env
	kubectl delete pod -l app=lab-env
	kubectl delete svc -l app=lab-env
	kubectl get pods,svc -l app=lab-env -o wide
# Install registry on localmachine 
run-registry:
	sudo docker run -d -p 5000:5000 --restart always --name registry registry:2

show-allpods:
	kubectl get svc -o wide
	
get-nodes:
	sudo kubectl get nodes 
