import models.com.example.platform.v1alpha1 as platformv1alpha1
import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.io.k8s.api.rbac.v1 as rbacv1
import models.io.k8s.api.core.v1 as corev1
import file
import base64

aws_access_key_id = file.read_env("UP_AWS_ACCESS_KEY_ID")
aws_secret_access_key = file.read_env("UP_AWS_SECRET_ACCESS_KEY")
aws_session_token = file.read_env("UP_AWS_SESSION_TOKEN")

_items = [
    metav1alpha1.E2ETest{
        metadata.name: "composite-bucket-kcl"
        spec= {
            initResources: [
                rbacv1.ClusterRoleBinding{
                    metadata.name: "upbound-controller-manager-cluster-admin"
                    roleRef: {
                        apiGroup: "rbac.authorization.k8s.io"
                        kind: "ClusterRole"
                        name: "cluster-admin"
                    }
                    subjects: [
                        {
                            kind: "ServiceAccount"
                            name: "upbound-controller-manager"
                            namespace: "crossplane-system"
                        }
                    ]
                }
                corev1.Secret{
                    metadata: {
                        name: "aws-creds"
                        namespace: "crossplane-system"
                    }
                    data={
                        "credentials": base64.encode("""[default]
aws_access_key_id = ${aws_access_key_id}
aws_secret_access_key = ${aws_secret_access_key}
aws_session_token = ${aws_session_token}
""")
                    }
                }
            ]
            crossplane.autoUpgrade.channel: "Rapid"
            defaultConditions: ["Ready"]
            manifests: [
               platformv1alpha1.StorageBucket{
                metadata: {
                    name: "up-ack-example"
                    namespace: "default"
                }
                spec: {
                    parameters: {
                        region: "us-west-1"
                        versioning: True
                    }
                }
               }
            ]
            skipDelete: False
            timeoutSeconds: 4500
        }
    }
]
items= _items