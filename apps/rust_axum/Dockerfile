FROM rust:1-buster

# 2. Copy the files in your machine to the Docker image
COPY ./ ./

# Build your program for release
# RUN cargo check
# RUN cargo build
RUN SQLX_OFFLINE=true cargo build --release

# Run the binary
EXPOSE 8080
# CMD ["./target/debug/service"]
CMD ["./target/release/service"]
# CMD cargo run
