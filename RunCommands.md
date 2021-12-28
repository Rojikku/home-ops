# Log of Run Commands to get to cluster state
Set k8s master to no schedule
`kubectl taint node k8s-0 node-role.kubernetes.io/master=true:NoSchedule`

Specify node with zwave controller
`kubectl label node k8s-4 feature.node.kubernetes.io/custom-zwave=true`
