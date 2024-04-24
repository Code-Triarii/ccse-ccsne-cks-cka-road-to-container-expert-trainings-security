# Kubernetes Audit Logs

- [Kubernetes Audit Logs](#kubernetes-audit-logs)
  - [Theory](#theory)
    - [Kube-apiserver Logs](#kube-apiserver-logs)
    - [Strategies to Gather Logs](#strategies-to-gather-logs)
  - [Use Cases](#use-cases)
    - [Configuring API Server audit logs](#configuring-api-server-audit-logs)

## Theory

Kubernetes audit logs provide a detailed record of the sequence of activities that have occurred within the cluster. They are an essential resource for administrators to understand the activities within a cluster, diagnose problems, or understand the behavior of the system.

There are several types of logs that are relevant in a Kubernetes cluster:

- **Application Logs**: These are the logs that your application components output. They can be found in the pod's log files.

- **System Component Logs**: These logs are from the Kubernetes system components, such as the kubelet and kube-proxy.

- **Audit Logs**: These logs record requests to the Kubernetes API. They provide a chronological set of records documenting the sequence of activities that have affected system by individual users, administrators or other components.

### Kube-apiserver Logs

The kube-apiserver is the main source of audit logs in Kubernetes. It processes all requests made to the Kubernetes API Server and, as such, all these interactions can be logged for auditing purposes.

There are two main ways to output these logs:

- **Log to file**: The kube-apiserver can be configured to write audit logs to a file. This is controlled by the `--audit-log-path` flag.

- **Dynamic Webhook**: The kube-apiserver can be configured to send audit logs to a remote server. This is controlled by the `--audit-webhook-config-file` flag.

### Strategies to Gather Logs

There are several strategies to gather logs in a Kubernetes cluster:

- **Using `kubectl logs` command**: This command allows you to print the logs for a specific container in a pod.

- **Using a logging agent**: A logging agent is a tool that automatically collects logs from your cluster and forwards them to a log management solution. Examples include Fluentd, Fluent Bit, and Logstash.

- **Using a log management solution**: These are platforms that provide centralized log management, such as Elasticsearch, Loggly, or Splunk.

## Use Cases

### Configuring API Server audit logs

**For this exercise I will use the single node cluster configured in VM (check [environments](../../environment/kubeadm_single_node/README.md))**

Reference: [Cluster Audit - Official Documentation](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/).

1. We are going to start by defining an `audit-policy.yaml` and ensuring that is available at a location in master node. In my case `/root/k8s-audit/audit-policy.yaml`.

```bash
mkdir -p /root/k8s-audit
cat > /root/k8s-audit/audit-policy.yaml<<EOL
apiVersion: audit.k8s.io/v1 # This is required.
kind: Policy
# Don't generate audit events for all requests in RequestReceived stage.
omitStages:
  - "RequestReceived"
rules:
  # Log pod changes at RequestResponse level
  - level: RequestResponse
    resources:
    - group: ""
      # Resource "pods" doesn't match requests to any subresource of pods,
      # which is consistent with the RBAC policy.
      resources: ["pods"]
  # Log "pods/log", "pods/status" at Metadata level
  - level: Metadata
    resources:
    - group: ""
      resources: ["pods/log", "pods/status"]

  # Don't log requests to a configmap called "controller-leader"
  - level: None
    resources:
    - group: ""
      resources: ["configmaps"]
      resourceNames: ["controller-leader"]

  # Don't log watch requests by the "system:kube-proxy" on endpoints or services
  - level: None
    users: ["system:kube-proxy"]
    verbs: ["watch"]
    resources:
    - group: "" # core API group
      resources: ["endpoints", "services"]

  # Don't log authenticated requests to certain non-resource URL paths.
  - level: None
    userGroups: ["system:authenticated"]
    nonResourceURLs:
    - "/api*" # Wildcard matching.
    - "/version"

  # Log the request body of configmap changes in kube-system.
  - level: Request
    resources:
    - group: "" # core API group
      resources: ["configmaps"]
    # This rule only applies to resources in the "kube-system" namespace.
    # The empty string "" can be used to select non-namespaced resources.
    namespaces: ["kube-system"]

  # Log configmap and secret changes in all other namespaces at the Metadata level.
  - level: Metadata
    resources:
    - group: "" # core API group
      resources: ["secrets", "configmaps"]

  # Log all other resources in core and extensions at the Request level.
  - level: Request
    resources:
    - group: "" # core API group
    - group: "extensions" # Version of group should NOT be included.

  # A catch-all rule to log all other requests at the Metadata level.
  - level: Metadata
    # Long-running requests like watches that fall under this rule will not
    # generate an audit event in RequestReceived.
    omitStages:
      - "RequestReceived"
EOL
```

2. After that, we need to apply the following changes to the `/etc/kubernetes/manifest/kube-apiserver.yaml`:

```yaml
...
  containers:
...
    command:
    ...
      - --audit-policy-file=/etc/kubernetes/audit-policy.yaml
      - --audit-log-path=/var/log/kubernetes/audit/audit.log
...
    volumeMounts:
      - mountPath: /etc/kubernetes/audit-policy.yaml
        name: audit
        readOnly: true
      - mountPath: /var/log/kubernetes/audit/
        name: audit-log
        readOnly: false
...
  volumes:
...
  - name: audit
    hostPath:
      path: /root/k8s-audit/audit-policy.yaml
      type: File

  - name: audit-log
    hostPath:
      path: /var/log/kubernetes/audit/
      type: DirectoryOrCreate
```

> \[!IMPORTANT\]
> Notice that we need to mount two volumes to make sure we are sharing the file with the api-server pods and that the output audit logs generated in the pod are accessible to the host node (master) for retrieval.