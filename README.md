# Outline

Here is demostrate scripts to teach how to build a corestone 3000 fvp yolo learning lab with kebernates on Ampere Altra platform. 


# Host

The directory Host is host install scripts, it will install k3s in the system. 

# Docker

Default VNC password is ampere

# k3s

## Setup Registry Proxy 

### Install docker local registry
make registry

### Modify k3s mirror configureation about machine ip

edit k3s/registries.yaml

### alias

it can easy to run alias command to simply the input command, can put it to ~/.bashrc

alias k=sudo kubectl 


### Forget forward port 

$ k get svc
NAME           TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)          AGE
kubernetes     ClusterIP      10.43.0.1       <none>         443/TCP          18h
lab-1-ssh      LoadBalancer   10.43.35.17     192.168.1.38   22:30164/TCP     18m
lab-1-vnc      LoadBalancer   10.43.64.151    192.168.1.38   5901:30136/TCP   18m




## Reference Document
 [Corstone-300 FVP Examples](https://github.com/heslabs/corstone300_fvp_yolo)
 