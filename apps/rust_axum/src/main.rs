#![allow(unused)] // silence unused warnings while exploring (to comment out)
use axum::{
    extract::Extension,
    http::StatusCode,
    response::IntoResponse,
    routing::{get, post},
    Router,
};
use serde::{Deserialize, Serialize};
use serde_json::json;
use sqlx::postgres::{PgPoolOptions, PgRow};
use sqlx::PgPool;
use sqlx::{FromRow, Row};
use std::net::SocketAddr;
use std::process;
use tower::ServiceBuilder;
use uuid::Uuid;

// #[derive(Debug, FromRow)]
#[derive(Debug)]
struct Counter {
    count: Option<i64>,
}

#[derive(Debug)]
struct Insert {
    time: String,
}

#[derive(Clone)]
struct ApiContext {
    pool: PgPool,
}

#[tokio::main]
async fn main() {
    // initialize tracing
    tracing_subscriber::fmt::init();
    dotenv::dotenv().expect("Unable to load environment variables from .env file");
    let db_url = std::env::var("DATABASE_URL").expect("Unable to read DATABASE_URL env var");
    println!("db_url: {db_url}");

    let pool = PgPoolOptions::new()
        .max_connections(10)
        .connect(&db_url)
        .await
        .expect("Unable to connect to Postgres");

    // build our application with a route
    let app = Router::new()
        .route("/", get(root))
        .route("/hello", get(get_hello))
        .route("/insert", post(post_insert_event))
        .layer(ServiceBuilder::new().layer(Extension(ApiContext { pool })));

    println!("App pid is {}", process::id());
    println!("listening on 0.0.0.0:8080");
    axum::Server::bind(&"0.0.0.0:8080".parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}

// basic handler that responds with a static string
async fn root() -> &'static str {
    "Root of rust_axum"
}

// basic handler that responds with a static string
async fn get_hello() -> &'static str {
    "Hello from rust_axum"
}

async fn post_insert_event(
    // this argument tells axum to parse the request body
    // as JSON into a `CreateUser` type
    ctx: Extension<ApiContext>,
    axum::Json(payload): axum::Json<CreateUser>,
) -> impl IntoResponse {
    let id = Uuid::new_v4();
    let data: sqlx::types::Json<CreateUser> = sqlx::types::Json(payload.clone());
    sqlx::query("INSERT INTO rust_axum(id, data) VALUES ($1, $2);")
        // Bind the (Serializable) payload via sqlx::types::Json
        .bind(id)
        .bind(data)
        .execute(&ctx.pool)
        .await
        .ok();

    // this will be converted into a JSON response
    // with a status code of `201 Created`
    (StatusCode::CREATED, axum::Json(payload))
}

// the input to our `create_user` handler
#[derive(Serialize, Deserialize, Debug, Clone)]
struct CreateUser {
    key: String,
}

// the output to our `create_user` handler
#[derive(Serialize)]
struct User {
    id: u64,
    username: String,
}
