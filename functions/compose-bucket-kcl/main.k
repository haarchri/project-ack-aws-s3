import models.aws.k8s.services.s3.v1alpha1 as s3v1alpha1

oxr = option("params").oxr # observed composite resource
ocds = option("params").ocds # observed composed resources
_dxr = option("params").dxr # desired composite resource
dcds = option("params").dcds # desired composed resources

_metadata = lambda name: str -> any {
    { annotations = { "krm.kcl.dev/composition-resource-name" = name }}
}

# Check if bucket is ready based on ACK.ResourceSynced condition
_bucketReady = lambda -> bool {
    result = False
    if "bucket" in ocds:
        bucketResource = ocds["bucket"]
        if bucketResource?.Resource?.status?.conditions:
            result = any condition in bucketResource.Resource.status.conditions {
                condition.type == "ACK.ResourceSynced" and condition.status == "True"
            }
    result
}

bucketReady = _bucketReady()

_bucketSpec = s3v1alpha1.S3ServicesK8sAwsV1alpha1BucketSpec{
    name = oxr.metadata.name
    ownershipControls = {
        rules = [{
            objectOwnership = "BucketOwnerPreferred"
        }]
    }
    publicAccessBlock = {
        blockPublicACLs = False
        ignorePublicACLs = False
        restrictPublicBuckets = False
        blockPublicPolicy = False
    }
    encryption = {
        rules = [{
            applyServerSideEncryptionByDefault = {
                sseAlgorithm = "AES256"
            }
            bucketKeyEnabled = True
        }]
    }
}

if oxr.spec.parameters.versioning:
    _bucketSpec.versioning = {
        status = "Enabled"
    }

bucket = s3v1alpha1.Bucket{
    metadata: _metadata("bucket") | {
        annotations : {
            "krm.kcl.dev/ready" = str(bucketReady)
            "services.k8s.aws/region": oxr.spec.parameters.region
        }
    }
    spec = _bucketSpec
}

items = [bucket]
