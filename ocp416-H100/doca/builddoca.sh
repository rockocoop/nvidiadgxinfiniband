
podman build \
     --build-arg D_OS=rhcos4.16 \
    --build-arg D_ARCH=x86_64 \
    --build-arg D_KERNEL_VER=5.14.0-427.49.1.el9_4.x86_64 \
    --build-arg D_DOCA_VERSION=2.9.1 \
    --build-arg D_OFED_VERSION=25.04-0.6.1.0 \
    --build-arg D_BASE_IMAGE="quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:dde3cd6a75d865a476aa7e1cab6fa8d97742401e87e0d514f3042c3a881e301f" \
    --build-arg D_FINAL_BASE_IMAGE=registry.access.redhat.com/ubi9/ubi:9.4 \
    --tag 25.04-0.6.1.0-5.14.0-427.49.1.el9_4.x86_64-rhcos4.16-amd64 \
    -f RHEL_Dockerfile \
    --target precompiled .
