
#!/bin/bash

# User number 
LABUSER_COUNT=3

NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')

# Apply new seting incase delete old setting 
make apply-setting

# create Service for lab user
for i in $(seq 0 $((LABUSER_COUNT-1))); do
  LABUSER_ID="lab-$((i+1))"
  POD_NAME="lab-pod-$i"

  # 創建 LoadBalancer Service for SSH
  kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: ${LABUSER_ID}-ssh
spec:
  type: LoadBalancer
  selector:
    app: lab-env
    statefulset.kubernetes.io/pod-name: ${POD_NAME}  
  ports:
  - protocol: TCP
    port: 22
    targetPort: 22
EOF

  # LoadBalancer Service for VNC
  kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: ${LABUSER_ID}-vnc
spec:
  type: LoadBalancer
  selector:
    app: lab-env
    statefulset.kubernetes.io/pod-name: ${POD_NAME}
  ports:
  - protocol: TCP
    port: 5901
    targetPort: 5901
EOF
done

# output command
echo "======= COMMAND ======="
for i in $(seq 0 $((LABUSER_COUNT-1))); do
  LABUSER_ID="lab-$((i+1))"
  SSH_PORT=$(kubectl get svc ${LABUSER_ID}-ssh -o jsonpath='{.spec.ports[0].nodePort}')
  VNC_PORT=$(kubectl get svc ${LABUSER_ID}-vnc -o jsonpath='{.spec.ports[0].nodePort}')
  
  echo "LABUSER ${LABUSER_ID}:"
  echo "  SSH:  ssh -X lab@${NODE_IP} -p ${SSH_PORT}"
  echo "  VNC:  vnc://${NODE_IP}:${VNC_PORT}"
done
