TMPDIR := /tmp/infrastructure-docker
DSTDIR := $(TMPDIR)/v0.3.7
CAPD := $(TMPDIR)/kubeconfig
export KIND_EXPERIMENTAL_DOCKER_NETWORK=bridge

## Boostrap a CAPD controller 
capi:
	@mkdir -p $(DSTDIR)
	@cp ./capd/infrastructure-components.yaml ./capd/metadata.yaml $(DSTDIR)
	kubectl -n capd-system get deploy/capd-controller-manager >/dev/null 2>&1 || \
		clusterctl init --config ./clusterctl.yaml \
		--core cluster-api:v0.3.7 \
		--bootstrap kubeadm:v0.3.7 \
		--control-plane kubeadm:v0.3.7 \
		--infrastructure docker:v0.3.7
	kubectl -n capd-system wait --for=condition=Available deploy/capd-controller-manager --timeout=3m >/dev/null


capi-check:
	kubectl wait --for=condition=Available --timeout=90s deploy/capd-controller-manager -n capd-system


## Create a single CAPD cluster
capd: capi-check
	@kubectl apply -f ./capd/cluster.yaml >/dev/null
