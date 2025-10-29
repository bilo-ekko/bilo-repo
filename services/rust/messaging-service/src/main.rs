use actix_web::{get, web, App, HttpResponse, HttpServer, Responder};
use serde::{Deserialize, Serialize};
use std::env;

#[derive(Serialize, Deserialize)]
struct HealthResponse {
    ok: bool,
    service: String,
    #[serde(rename = "thisIsRust")]
    this_is_rust: bool,
}

#[derive(Serialize, Deserialize)]
struct MessageRequest {
    to: String,
    subject: String,
    body: String,
    #[serde(rename = "type")]
    message_type: String,
}

#[derive(Serialize, Deserialize)]
struct MessageResponse {
    success: bool,
    message_id: String,
    service: String,
}

#[get("/")]
async fn index() -> impl Responder {
    HttpResponse::Ok().body("Messaging Service - Rust Edition")
}

#[get("/health")]
async fn health() -> impl Responder {
    let response = HealthResponse {
        ok: true,
        service: "messaging-service".to_string(),
        this_is_rust: true,
    };
    HttpResponse::Ok().json(response)
}

#[get("/health")]
async fn health_check() -> impl Responder {
    let response = HealthResponse {
        ok: true,
        service: "messaging-service".to_string(),
        this_is_rust: true,
    };
    HttpResponse::Ok().json(response)
}

#[actix_web::post("/messages")]
async fn send_message(msg: web::Json<MessageRequest>) -> impl Responder {
    log::info!(
        "Sending {} message to: {} with subject: {}",
        msg.message_type,
        msg.to,
        msg.subject
    );

    // Simulate message sending
    let response = MessageResponse {
        success: true,
        message_id: format!("msg_{}", uuid::Uuid::new_v4()),
        service: "messaging-service".to_string(),
    };

    HttpResponse::Ok().json(response)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    let port = env::var("PORT").unwrap_or_else(|_| "3009".to_string());
    let bind_address = format!("0.0.0.0:{}", port);

    log::info!("🚀 Starting Messaging Service (Rust) on {}", bind_address);

    HttpServer::new(|| {
        App::new()
            .service(index)
            .service(health)
            .service(health_check)
            .service(send_message)
    })
    .bind(&bind_address)?
    .run()
    .await
}

