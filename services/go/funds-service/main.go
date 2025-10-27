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
		AppName: "Funds Service",
	})

	// Middleware
	app.Use(recover.New())
	app.Use(logger.New())
	app.Use(cors.New())

	// Routes
	app.Get("/health", healthCheck)
	app.Post("/funds/aggregate", aggregateFunds)
	app.Post("/funds/reconcile", reconcileFunds)
	app.Get("/funds/:id", getFundDetails)

	// Get port from environment or default
	port := os.Getenv("PORT")
	if port == "" {
		port = "3101"
	}

	log.Printf("💵 Funds Service is running on: http://localhost:%s\n", port)
	log.Fatal(app.Listen(":" + port))
}

func healthCheck(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{
		"status":  "healthy",
		"service": "funds-service",
	})
}

func aggregateFunds(c *fiber.Ctx) error {
	// TODO: Implement concurrent fund aggregation using goroutines
	return c.JSON(fiber.Map{
		"message": "Funds aggregated",
	})
}

func reconcileFunds(c *fiber.Ctx) error {
	// TODO: Implement reconciliation flows
	return c.JSON(fiber.Map{
		"message": "Funds reconciled",
	})
}

func getFundDetails(c *fiber.Ctx) error {
	id := c.Params("id")
	// TODO: Implement fund details retrieval
	return c.JSON(fiber.Map{
		"id":      id,
		"message": "Fund details",
	})
}
