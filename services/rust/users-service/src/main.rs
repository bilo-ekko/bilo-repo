use actix_cors::Cors;
use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use bilo_shared_utils::{create_success_response, hello_from_shared_utils};
use serde::{Deserialize, Serialize};
use std::env;
use std::sync::RwLock;

#[derive(Serialize, Deserialize)]
struct HealthResponse {
    ok: bool,
    service: String,
    stack: String,
}

#[derive(Serialize, Deserialize, Clone)]
struct User {
    id: String,
    email: String,
    name: String,
    created_at: String,
}

#[derive(Serialize, Deserialize)]
struct CreateUserRequest {
    email: String,
    name: String,
}

#[derive(Serialize, Deserialize)]
struct UserResponse {
    success: bool,
    user: User,
    service: String,
}

#[derive(Serialize, Deserialize)]
struct UsersListResponse {
    success: bool,
    users: Vec<User>,
    service: String,
    count: usize,
}

// In-memory storage for demo purposes
// In production, this would be replaced with a database
static USERS: RwLock<Vec<User>> = RwLock::new(Vec::new());

#[get("/")]
async fn index() -> impl Responder {
    HttpResponse::Ok().body("Users Service - Rust Edition")
}

#[get("/health")]
async fn health() -> impl Responder {
    let response = HealthResponse {
        ok: true,
        service: "users-service".to_string(),
        stack: "Rust".to_string(),
    };
    HttpResponse::Ok().json(response)
}

#[get("/shared-utils-demo")]
async fn shared_utils_demo() -> impl Responder {
    let message = hello_from_shared_utils("users-service");
    let data = serde_json::json!({ "message": message });
    let response = create_success_response(data);
    HttpResponse::Ok().json(response)
}

#[post("/users")]
async fn create_user(req: web::Json<CreateUserRequest>) -> impl Responder {
    log::info!("Creating user: {} ({})", req.email, req.name);

    let user = User {
        id: uuid::Uuid::new_v4().to_string(),
        email: req.email.clone(),
        name: req.name.clone(),
        created_at: chrono::Utc::now().to_rfc3339(),
    };

    USERS.write().unwrap().push(user.clone());

    let response = UserResponse {
        success: true,
        user,
        service: "users-service".to_string(),
    };

    HttpResponse::Created().json(response)
}

#[get("/users")]
async fn get_users() -> impl Responder {
    let users: Vec<User> = USERS.read().unwrap().clone();
    
    let response = UsersListResponse {
        success: true,
        users: users.clone(),
        service: "users-service".to_string(),
        count: users.len(),
    };

    HttpResponse::Ok().json(response)
}

#[get("/users/{id}")]
async fn get_user(path: web::Path<String>) -> impl Responder {
    let user_id = path.into_inner();
    
    let user = USERS.read().unwrap().iter().find(|u| u.id == user_id).cloned();

    match user {
        Some(user) => {
            let response = UserResponse {
                success: true,
                user,
                service: "users-service".to_string(),
            };
            HttpResponse::Ok().json(response)
        }
        None => {
            let error_response = serde_json::json!({
                "success": false,
                "error": "User not found",
                "service": "users-service"
            });
            HttpResponse::NotFound().json(error_response)
        }
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    let port = env::var("PORT").unwrap_or_else(|_| "3012".to_string());
    let bind_address = format!("0.0.0.0:{}", port);

    log::info!("🚀 Starting Users Service (Rust) on {}", bind_address);

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
            .service(shared_utils_demo)
            .service(create_user)
            .service(get_users)
            .service(get_user)
    })
    .bind(&bind_address)?
    .run()
    .await
}

