package main

import (
	"log"
	"os"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
)

func main() {
	app := fiber.New(fiber.Config{
		AppName: "Transactions Service",
	})

	// Middleware
	app.Use(recover.New())
	app.Use(logger.New())
	app.Use(cors.New())

	// Routes
	app.Get("/health", healthCheck)
	app.Post("/transactions", createTransaction)
	app.Get("/transactions/:id", getTransaction)
	app.Post("/transactions/:id/reverse", reverseTransaction)

	// Get port from environment or default
	port := os.Getenv("PORT")
	if port == "" {
		port = "3100"
	}

	log.Printf("💰 Transactions Service is running on: http://localhost:%s\n", port)
	log.Fatal(app.Listen(":" + port))
}

func healthCheck(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{
		"status":  "healthy",
		"service": "transactions-service",
		"stack":   "Go (Fiber)",
	})
}

func createTransaction(c *fiber.Ctx) error {
	// TODO: Implement transaction creation with idempotency
	return c.JSON(fiber.Map{
		"message": "Transaction created",
	})
}

func getTransaction(c *fiber.Ctx) error {
	id := c.Params("id")
	// TODO: Implement transaction retrieval
	return c.JSON(fiber.Map{
		"id":      id,
		"message": "Transaction details",
	})
}

func reverseTransaction(c *fiber.Ctx) error {
	id := c.Params("id")
	// TODO: Implement transaction reversal
	return c.JSON(fiber.Map{
		"id":      id,
		"message": "Transaction reversed",
	})
}
