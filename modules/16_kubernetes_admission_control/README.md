# Admission Controllers

- [Admission Controllers](#admission-controllers)
  - [Validating and Mutating Admission Controllers with OPA / OPA Gatekeeper and Kyverno](#validating-and-mutating-admission-controllers-with-opa--opa-gatekeeper-and-kyverno)
    - [Open Policy Agent (OPA) / OPA Gatekeeper](#open-policy-agent-opa--opa-gatekeeper)
      - [Getting started with OPA Gatekeeper](#getting-started-with-opa-gatekeeper)
        - [Use case 1: whitelist of repositories](#use-case-1-whitelist-of-repositories)
        - [Use case 2: mutating pods to remove privilege containers](#use-case-2-mutating-pods-to-remove-privilege-containers)
    - [Kyverno](#kyverno)
      - [Getting started with Kyverno](#getting-started-with-kyverno)
        - [Use case 1: Whitelisted repositories](#use-case-1-whitelisted-repositories)
        - [Use case 2: Mutating - Non-privileged containers](#use-case-2-mutating---non-privileged-containers)

Admission Controllers are a powerful feature in Kubernetes that are used to govern how clusters are used and to enforce certain policies. They are part of the kube-apiserver and intercept requests to the Kubernetes API server prior to persistence of the object, but after the request is authenticated and authorized.

Admission controllers can modify incoming requests to enforce custom defaults, limitations, or other cluster policies. They can also reject requests to enforce critical policies.

There are several types of Admission Controllers available in Kubernetes:

- **NamespaceLifecycle**: This controller prevents operations in namespaces that are in the process of being deleted.

- **LimitRanger**: This controller enforces defaults and limits for Pods and their containers.

- **ServiceAccount**: This controller automates the creation of service accounts and the association of service accounts with pods.

- **DefaultStorageClass**: This controller automatically adds a default storage class to PersistentVolumeClaims that don't have any storage class specified.

- **MutatingAdmissionWebhook**: This controller is used to call external admission webhooks that mutate the object.

- **ValidatingAdmissionWebhook**: This controller is used to call external admission webhooks that validate the object.

- **PodSecurityPolicy**: This controller enforces Pod Security Policies in your cluster.

- **NodeRestriction**: This controller limits the Node and Pod objects a kubelet can modify.

## Validating and Mutating Admission Controllers with OPA / OPA Gatekeeper and Kyverno

### Open Policy Agent (OPA) / OPA Gatekeeper

Open Policy Agent (OPA) is a general-purpose policy engine that unifies policy enforcement across the stack. OPA provides a high-level declarative language (Rego) that lets you specify policy as code.

OPA Gatekeeper is an open-source project that provides a first-class integration between OPA and Kubernetes. It is essentially an extension of OPA that's tailored for Kubernetes and uses Kubernetes-style APIs.

With OPA Gatekeeper, you can enforce policies using the `ValidatingAdmissionWebhook`. This allows you to validate, accept, or reject the resource based on the defined policies. You can also use the `MutatingAdmissionWebhook` to modify the resource data based on the policies.

#### Getting started with OPA Gatekeeper

Setting up OPA Gatekeeper in the cluster is not a tremendous challenge, thanks to the well prepared deployment resources and [documentation.](https://open-policy-agent.github.io/gatekeeper/website/docs/install/)

> \[!IMPORTANT\]
> In order to perform the subsequent steps, you will need `cluster-admin` role.

1. Deploy the OPA release.

```bash
(
OPA_VERSION="v3.15.0"
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/${OPA_VERSION}/deploy/gatekeeper.yaml
)
```

These commands will set up all the required components for OPA gatekeeper suite, including:

- `namespace`: gatekeeper-system
- `CDRS`: custom definition resources that are required by OPA.
- `serviceaccount`: gatekeeper admin.
- `Asociated RBAC` (clusterrole and clusterrolebinding) for the service account.
- `Secrets` with certs for TLS set-up of the containers.
- The deployment and services for: `gatekeeper-audi`t (*Audit performs periodic evaluations of existing resources against constraints, detecting pre-existing misconfigurations*) and `gatekeeper-controller-manager` (constantly watching the API server for modifications in objects defined by OPA CDRs to act upon).
- `Mutating and Validating webhook` configurations pointing to controller through the `gatekeeper-webhook-service`.

OPA, from the perspective of the usage, basically is focused in two Kubernetes object:

- `ConstrainTemplate`: Defines the policy. Think of this as a function with parameters os it contains the logic based and its flexible to receive a set of properties (parameters) so it can be instantiated for the same use case by different scenarios (ej. based on labels, passing allowed repos, etc.)
- `Constrains`: These are the instantiation of the functions (`ConstrainTemplates`) passing the required properties for enabling the policy.

To showcase how OPA can be configured, I am going to explain a set of sample scenarios using the **single master node (2 workers) cluster**. You can use the one that suites you best from the [environment](../../environment) or any cluster you may have available to interact with.

##### Use case 1: whitelist of repositories

1. Firstly we create the ConstrainTemplate.

```yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8swhitelistedimages # These must match the constrains name, the kind in crd definition and also the package name
spec:
  crd:
    spec:
      names:
        kind: k8swhitelistedimages
      validation:
        openAPIV3Schema:
          type: object
          # The properties are like 'parameters' to the function. Here the schema is defined
          # In this case an array of str containing the pattern for the whitelisted images.
          properties:
            images:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        # Declare the package name
        package k8swhitelistedimages

        # Define a set of whitelisted images from the input parameters
        whitelisted_images = {images |
            images = input.parameters.images[_]
        }

        # Check if the image string matches any of the patterns in the whitelisted images
        images_whitelisted(str, patterns) {
            # [_] represents the wildcard operator, which allows us to iterate over the patterns
            image_matches(str, patterns[_])
        }

        # Check if the image string contains the pattern
        image_matches(str, pattern) {
            contains(str, pattern)
        }

        # Define a violation rule that generates a message when a pod uses an image that is not whitelisted
        violation[{"msg": msg}] {
          # Get the pod object from the input review
          input.review.object
          # Get the image used by each container in the pod
          image := input.review.object.spec.containers[_].image
          # Get the name of the pod
          name := input.review.object.metadata.name
          # Check if the image is not whitelisted
          not images_whitelisted(image, whitelisted_images)
          # Generate a message indicating the violation
          msg := sprintf("pod %q has invalid image %q. Please, contact your DevOps. Follow the whitelisted images %v", [name, image, whitelisted_images])
        }
```

This, as explained, defines the "function" preparing the parameters (properties field)

2. After we create the Constrain that instantiates the template.

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: k8swhitelistedimages # The name must match the ConstraintTemplate name
metadata:
  name: only-allowed-images
spec:
  match:
    kinds:
      - apiGroups: ["*"]
      # Determines to which object is applied.
        kinds:
          - Pod
    # Specifies the namespace. By default this is applied to all namespaces.
    namespaces:
      - "demo"
  parameters:
    # List of images patterns that the image is going to be tested against.
    images: ["docker.io/library", "pedroarias1015/"]
```

![Showcase OPA](img/opa.gif)

##### Use case 2: mutating pods to remove privilege containers

OPA Gatekeeper project allows several types of mutation. All types available are listed in [Official Documentation - Mutation](https://open-policy-agent.github.io/gatekeeper/website/docs/mutation)

In this case, we are going to leverage mutating webhook configuration to force all containers in the "demo" namespace to be set as `privileged=false`.

For this we just need to create the `Assing` kind from `mutations.gatekeeper.sh/v1`.

```yaml
apiVersion: mutations.gatekeeper.sh/v1
kind: Assign
metadata:
  name: demo-privileged
spec:
# Specifies to which resources the mutation applies
  applyTo:
  - groups: [""]
    kinds: ["Pod"]
    versions: ["v1"]
  match:
    scope: Namespaced
    kinds:
    - apiGroups: ["*"]
      kinds: ["Pod"]
    # Limits to demo namespace
    namespaces: ["demo"]
  # The mutation is applied to the securityContext field of the container
  location: "spec.containers[name: *].securityContext.privileged"
  parameters:
    assign:
      value: false
```

![Mutating](img/opa2.gif)

---

### Kyverno

Kyverno is a policy engine designed specifically for Kubernetes. It can validate, mutate, and generate configurations using admission controls.

With Kyverno, policies are managed as Kubernetes resources and no new language is required to write policies. This allows you to validate, mutate, and generate configurations using the `ValidatingAdmissionWebhook` and `MutatingAdmissionWebhook`.

Kyverno allows you to validate policies against the live state of the Kubernetes resources. This makes it different from OPA Gatekeeper, which only allows you to validate policies against the static configuration of the resources.

Both OPA Gatekeeper and Kyverno provide a robust way to manage and enforce policies in your Kubernetes clusters, and the choice between them depends on your specific use case and requirements.

#### Getting started with Kyverno

To install kyverno, we are going to leverage the helm chart available at the Artifact Hub.

1. Add the repo and update.

```bash
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
```

> \[!TIP\]
> Kyverno has another chart `kyverno/kyverno-policies` that implements Pod security standards to reach a high level of security across workload. Deserve that you take a look at it 😉

2. Install the chart setting up desired number of replicas:

```bash
kubectl create ns kyverno

kubectl config set-context --current --namespace kyverno

helm install kyverno kyverno/kyverno  \
--set admissionController.replicas=3 \
--set backgroundController.replicas=2 \
--set cleanupController.replicas=2 \
--set reportsController.replicas=2
```

![Kyverno install](img/kyverno-install.png)

##### Use case 1: Whitelisted repositories

We are going to reproduce the same behavior that we managed to obtain with OPA, with kyverno simply by creating the following resource:

```yaml
apiVersion: kyverno.io/v1
# If is we want this to be cluster-wide then ClusterPolicy and remove namespace.
# In this case we are only applying it to namespace demo.
kind: Policy
metadata:
  name: whitelist-image
  namespace: demo
spec:
  validationFailureAction: Enforce
  # This preserves any workloads not matching the policy, created before the policy (a non-compliant existing pod won't be removed.)
  background: false
  rules:
  - name: check-container-image
    match:
      any:
      - resources:
          kinds:
          - Pod
    validate:
      message: Images must be either from docker.io/library or pedroarias1015
      # anyPattern determines that if any of those patterns comply, then the rule validates.
      anyPattern:
        - spec:
            containers:
            - image: "docker.io/library/*"
        - spec:
            containers:
            - image: "pedroarias1015/*"
```

![Kyverno sample 1](img/kyverno.gif)

##### Use case 2: Mutating - Non-privileged containers

Same as we did with OPA, we are going to stablish the same behavior with kyverno `mutate` policy to change privileged to `false`.

```yaml
apiVersion: kyverno.io/v1
kind: Policy
metadata:
  name: non-privileged-containers
  namespace: demo
spec:
  rules:
  - name: modify-privileged-containers
    match:
      any:
      - resources:
          kinds:
          - Pod
    mutate:
      patchStrategicMerge:
      # Add the annotation to the pod
        metadata:
          annotations:
            "kyverno.io/mutated-modify-privileged-containers": "true"
        spec:
          containers:
          # Anchor meaning all containers (if name = "*")
            - (name): "*"
              # Sets the securityContext to non-privileged
              securityContext:
                privileged: false
```

![kyverno mutate](img/kyverno2.gif)