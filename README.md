# Outline

Here is demostrate scripts to teach how to build a corestone 3000 fvp yolo learning lab with kebernates on Ampere Altra platform. 


# Host

The directory Host is the docker image build scripts for the Ampere host machine.

In the directory
```
make build
```

it will use docker to build a image for corestone3000 ampere lab,
then run the following command to test it

```
make daemon
```

Unlike regular docker image, it will not bring you to bash console,
because it needs to stop on latest line for kubernetes.

Right now it can use anyone VNC viewer to access it
```<host ip>:5901``` or
```<host ip>:1``` depend on your vncviewer

Default VNC password is ```ampere```

More options can use command help to display it.
```
make help
```

# kubernetes

## Install k3s (lightweight kubernetes)
In this lab environment, we choice the Lightweight Kubernetes k3s,
it would be more easy to deploy on single server, homelab and edge .. e.g.

change to directory to k3s and run following command to install k3s

```
cd k3s ; make install
```

After install, it can use command to check current status

```
kubectl get nodes
```

The output will be

```
NAME      STATUS   ROLES                  AGE   VERSION
armtest   Ready    control-plane,master   9m    v1.31.5+k3s1
```


## Setup Registry Proxy 

In the lab, every instance to pull the image from docker hub is not reasonable, so we can run a registry sever on local. registry server has docker image. here is command to run registry server in the docker.

```
sudo docker run -d -p 5000:5000 --restart always --name registry registry:2
```

or run following command in k3s directory

```
make run-registry
```

Check whether it is running

```
docker ps
```

The output will be

```
CONTAINER ID   IMAGE        COMMAND                  CREATED       STATUS       PORTS                                       NAMES
a61fbb06f19b   registry:2   "/entrypoint.sh /etc…"   1 days ago   Up 5 hours   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   registry
```

### alias

it can easy to run alias command to simply the input command, can put it to ~/.bashrc

```
alias k=sudo kubectl 
```


### Create LAB Users

Before create lab users, it needs to clean current lab users.

Show current lab users

```
make show-allpods
```

The output will be

```
lab-1-ssh      NodePort    10.43.81.154    <none>        22:30000/TCP      1d    app=lab-env,statefulset.kubernetes.io/pod-name=lab-pod-0
```

Remove current lab users

```make kill-allpods```

Create lab users

```
make create-lab
```

At the later message output, it will show lab IP and mapping ports

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

Default will create three lab users.
If wants to create more users, it needs to modify the statefulset.yaml
on around line 7, defult is 3, it can fill to fit current requirement.
```replicas: 3```

Then, modify the create-account.sh and modify LABUSER_COUNT=3 to coinstiance number in the file statefulset.yaml.

Run following command to apply new configuration

```
make kill-allpods
make create-lab
```

### Forget forward port 

the defualt port start from port 30000 + N\*2 , default is for ssh port and disable by default. 30000 + N\*2 + 1 is VNC port, N = LAB user order.

but still can use command **kubectl get svc** to get the information,
or run following command to get the port information

```
make show-allpods
```

The output will be

```
NAME           TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)          AGE
kubernetes     ClusterIP      10.43.0.1       <none>         443/TCP          18h
lab-1-ssh      LoadBalancer   10.43.35.17     192.168.1.38   22:30164/TCP     18m
lab-1-vnc      LoadBalancer   10.43.64.151    192.168.1.38   5901:30136/TCP   18m
```


## Reference Document
 [Corstone-300 FVP Examples](https://github.com/heslabs/corstone300_fvp_yolo)
 