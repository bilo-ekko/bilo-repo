use actix_cors::Cors;
use actix_web::{get, web, App, HttpResponse, HttpServer, Responder};
use bilo_shared_utils::{create_success_response, hello_from_shared_utils};
use serde::{Deserialize, Serialize};
use std::env;

#[derive(Serialize, Deserialize)]
struct HealthResponse {
    ok: bool,
    service: String,
    stack: String,
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
        stack: "Rust".to_string(),
    };
    HttpResponse::Ok().json(response)
}

#[get("/health")]
async fn health_check() -> impl Responder {
    let response = HealthResponse {
        ok: true,
        service: "messaging-service".to_string(),
        stack: "Rust".to_string(),
    };
    HttpResponse::Ok().json(response)
}

#[get("/shared-utils-demo")]
async fn shared_utils_demo() -> impl Responder {
    let message = hello_from_shared_utils("messaging-service");
    let data = serde_json::json!({ "message": message });
    let response = create_success_response(data);
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
        // Configure CORS to allow all origins (for development)
        let cors = Cors::default()
            .allow_any_origin()
            .allow_any_method()
            .allow_any_header()
            .max_age(3600);

        App::new()
            .wrap(cors)
            .service(index)
            .service(health)
            .service(health_check)
            .service(shared_utils_demo)
            .service(send_message)
    })
    .bind(&bind_address)?
    .run()
    .await
}

