# Outline

This repository contains demonstration scripts to guide you through building a Corestone 3000 FVP YOLO Learning Lab using Kubernetes on the Ampere Altra platform.

# Host

The `Host` directory contains Docker image build scripts tailored for the Ampere host machine.

In the `Host` directory, run:

```
make build
```

This command uses Docker to build an image for the Corestone 3000 Ampere Lab. After building, test it with the following command:


```
make daemon
```

Unlike a typical Docker image, this will not launch an interactive Bash console. Instead, it stops at the latest line to ensure compatibility with Kubernetes.
You can access the environment using any VNC viewer at either:

```<host ip>:5901``` or
```<host ip>:1``` depend on your vncviewer

The default VNC password is ```ampere```
The default system username is, `ubuntu` password is `ubuntu`

For additional options, use the help command to display them:
```
make help
```

# Kubernetes

## Install k3s (Lightweight Kubernetes)

In this lab environment, we use k3s, a lightweight Kubernetes distribution. It’s easier to deploy on a single server, homelab, or edge device, making it ideal for this setup.
Change to the `k3s` directory and run the following command to install k3s:

```
cd k3s
make install
```

After installation, check the current status with this command:

```
kubectl get nodes
```

The expected output will look like this:

```
NAME      STATUS   ROLES                  AGE   VERSION
armtest   Ready    control-plane,master   9m    v1.31.5+k3s1
```

## Setup Registry Proxy 

In this lab, pulling images directly from Docker Hub for every instance is inefficient. Instead, we can run a local registry server using a Docker image. Use the following command to start the registry server in Docker:

```
sudo docker run -d -p 5000:5000 --restart always --name registry registry:2
```

Alternatively, run this command from the `k3s` directory:

```
make run-registry
```

To verify that the registry is running, use:

```
docker ps
```

The output should resemble:

```
CONTAINER ID   IMAGE        COMMAND                  CREATED       STATUS       PORTS                                       NAMES
a61fbb06f19b   registry:2   "/entrypoint.sh /etc…"   1 days ago   Up 5 hours   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   registry
```

After running the registry server, push the built demo image to the local registry.
Run the following commands to tag and push the demo Docker image to the local registry:

```
make tag
make push
```

### Alias

To simplify command inputs, you can add an alias to your `~/.bashrc` file. For example:

```
alias k=sudo kubectl 
```


### Create LAB Users

Before creating new lab users, you need to remove any existing ones.
To display current lab users, run:

```
make show-allpods
```

The output will look like this:

```
lab-1-ssh      NodePort    10.43.81.154    <none>        22:30000/TCP      1d    app=lab-env,statefulset.kubernetes.io/pod-name=lab-pod-0
```

To remove current lab users, use:

```
make kill-allpods
```

To create new lab users, run:

```
make create-lab
```

The output will display the lab IP addresses and mapped ports for each user, such as:

```
LABUSER lab-1:
  SSH:  ssh -X lab@192.168.1.38 -p 30000
  VNC:  vnc://192.168.1.38:30001
LABUSER lab-2:
  SSH:  ssh -X lab@192.168.1.38 -p 30002
  VNC:  vnc://192.168.1.38:30003
LABUSER lab-3:
  SSH:  ssh -X lab@192.168.1.38 -p 30004
  VNC:  vnc://192.168.1.38:30005
```

By default, this creates three lab users. To create more users, modify the `statefulset.yaml` file around line 7, where the default is set to:

```replicas: 3```

Adjust this value to match your requirements. Then, update the `create-account.sh` file by changing `LABUSER_COUNT=3` to the same number of instances specified in `statefulset.yaml`.

Apply the new configuration with these commands:

```
make kill-allpods
make create-lab
```

### Forgot Forwarded Ports?

The default port assignments start at `30000 + N*2` for SSH (disabled by default) and `30000 + N*2 + 1` for VNC, where `N` is the lab user’s order (e.g., 0, 1, 2, ...).
To retrieve port information, use:

```
kubectl get svc
```

Alternatively, run this command to view detailed pod and port information:

```
make show-allpods
```

The output will look like this:

```
NAME           TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)          AGE
kubernetes     ClusterIP      10.43.0.1       <none>         443/TCP          18h
lab-1-ssh      LoadBalancer   10.43.35.17     192.168.1.38   22:30164/TCP     18m
lab-1-vnc      LoadBalancer   10.43.64.151    192.168.1.38   5901:30136/TCP   18m
```

# Corstone-300 FVP Demo

After logging into the system, open kconsole (located at *Start Menu > Applications > System > Konsole*). Then, change to the `/home/ubuntu/scripts/` directory, where you’ll find three scripts:

`1.Build_Vela.sh`: Uses Vela to build the YOLOv8 `.tflite` file for the Arm ML Embedded Evaluation Kit.
`2.Build_mlAPP.sh`: Compiles an `.axf` executable file using the ML Embedded Evaluation Kit, incorporating the pre-compiled Vela YOLOv8 model from the previous step.
`3.RunApp.sh`: Launches the Corstone-300 FVP Demo application.

Run the scripts in numerical order as listed.

## Reference Document
 [Corstone-300 FVP Examples](https://github.com/heslabs/corstone300_fvp_yolo)
 