.PHONY: build
build:
	cargo build --release

.PHONY: image
image:	build
	docker build -f Dockerfile . -t lsr-wasm

.PHONY: docker-run
demo-contents-not-seen: image
	docker run --name lsr-docker-run --runtime=io.containerd.wasmedge.v1 --platform wasi/wasm32 lsr-wasm
	docker export lsr-docker-run -o lsr-contents.tar
	tar -tvf lsr-contents.tar
	docker rm lsr-docker-run
	rm lsr-contents.tar

.PHONY: docker-run
demo-lsr-working: build
	wasmedge --dir /:${PWD}/target/wasm32-wasi/release target/wasm32-wasi/release/lsr.wasm
