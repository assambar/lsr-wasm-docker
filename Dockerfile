FROM scratch
COPY target/wasm32-wasi/release/lsr.wasm /
COPY target/wasm32-wasi/release/ /t-w-r/

ENTRYPOINT [ "/lsr.wasm" ]
