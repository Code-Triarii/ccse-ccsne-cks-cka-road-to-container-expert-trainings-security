# Admission Controllers

- [Admission Controllers](#admission-controllers)
  - [Validating and Mutating Admission Controllers with OPA / OPA Gatekeeper and Kyverno](#validating-and-mutating-admission-controllers-with-opa--opa-gatekeeper-and-kyverno)
    - [Open Policy Agent (OPA) / OPA Gatekeeper](#open-policy-agent-opa--opa-gatekeeper)
      - [Getting started with OPA Gatekeeper](#getting-started-with-opa-gatekeeper)
    - [Kyverno](#kyverno)
      - [Getting started with Kyverno](#getting-started-with-kyverno)

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



---

### Kyverno

Kyverno is a policy engine designed specifically for Kubernetes. It can validate, mutate, and generate configurations using admission controls.

With Kyverno, policies are managed as Kubernetes resources and no new language is required to write policies. This allows you to validate, mutate, and generate configurations using the `ValidatingAdmissionWebhook` and `MutatingAdmissionWebhook`.

Kyverno allows you to validate policies against the live state of the Kubernetes resources. This makes it different from OPA Gatekeeper, which only allows you to validate policies against the static configuration of the resources.

Both OPA Gatekeeper and Kyverno provide a robust way to manage and enforce policies in your Kubernetes clusters, and the choice between them depends on your specific use case and requirements.

#### Getting started with Kyverno


