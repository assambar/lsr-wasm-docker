# lsr-wasm-docker
Short lived example for trying to run recursive fs listing in a docker+wasm "container"

`lsr.wasm` does a recursive filesystem listing on the `/` path (or whatever is provided as first argument)

This repository tries to put it along with some other files in an OCI image and demonstrate if it can list the files and folders in the "container" spawned from that image.

# Prerequisites
 - `cargo` + `wasm32-wasi` target
 - make
 - docker+wasm
 - wasmedge 

# Steps
 - `make build` - downloads dependencies and builds lsr.wasm 
 - `make image` - builds a `lsr-wasm` image locally, including the lsr.wasm module along with sample files from `target/wasm32-wasi/release`
 - `make demo-contents-not-seen` - runs above image in a container, showing that nothing gets listed by lsr.wasm, then exports the container to show the files are there
 - `make demo-lsr-working` - runs `lsr-wasm` on wasmedge with mounted `target/wasm32-wasi/release` to show that it works as expected
 
# Observed output

As can be seen when we run `make demo-contents-not-seen` the lsr.wasm module when running via docker only prints
```
Starting from root_dir "/"
```
while exporting the container shows many files in the `/` folder and its subfolders.

```
docker run --name lsr-docker-run --runtime=io.containerd.wasmedge.v1 --platform wasi/wasm32 lsr-wasm
Starting from root_dir "/"
docker export lsr-docker-run -o lsr-contents.tar
tar -tvf lsr-contents.tar
drwxr-xr-x 0/0               0 2022-11-23 16:12 etc/
-rw-r--r-- 0/0               0 2022-11-23 16:12 etc/hostname
-rw-r--r-- 0/0               0 2022-11-23 16:12 etc/hosts
-rw-r--r-- 0/0               0 2022-11-23 16:12 etc/resolv.conf
-rwxr-xr-x 0/0         2065165 2022-11-23 16:12 lsr.wasm
drwxr-xr-x 0/0               0 2022-11-23 16:12 t-w-r/
-rw-r--r-- 0/0               0 2022-11-23 15:50 t-w-r/.cargo-lock
...
-rw-r--r-- 0/0             139 2022-11-23 15:50 t-w-r/lsr.d
hrwxr-xr-x 0/0               0 2022-11-23 16:12 t-w-r/lsr.wasm link to t-w-r/deps/lsr-a5bd9b0e789230dc.wasm
```
