import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.aws.k8s.services.s3.v1alpha1 as s3v1alpha1

_items = [
    metav1alpha1.CompositionTest{
        metadata.name: "composite-bucket-kcl"
        spec= {
            assertResources: [
                s3v1alpha1.Bucket{
                    metadata: {
                        annotations: {
                            "crossplane.io/composition-resource-name": "bucket"
                            "services.k8s.aws/region": "us-west-1"
                        }
                    }
                    spec: {
                        encryption: {
                            rules: [
                                {
                                    applyServerSideEncryptionByDefault: {
                                        sseAlgorithm: "AES256"
                                    }
                                    bucketKeyEnabled: True
                                }
                            ]
                        }
                        name: "up-ack-example"
                        ownershipControls: {
                            rules: [
                                {
                                    objectOwnership: "BucketOwnerPreferred"
                                }
                            ]
                        }
                        publicAccessBlock: {
                            blockPublicACLs: False
                            blockPublicPolicy: False
                            ignorePublicACLs: False
                            restrictPublicBuckets: False
                        }
                        versioning: {
                            status: "Enabled"
                        }
                    }
                }
            ]
            compositionPath: "apis/storagebuckets/composition.yaml"
            xrPath: "examples/storagebuckets/example.yaml"
            xrdPath: "apis/storagebuckets/definition.yaml"
            timeoutSeconds: 60
            validate: False
        }
    }
]
items= _items
