package main

import (
	"context"
	"log"

	"github.com/NMAMENDES2/Certified_Classic/db"
)

func main() {

	ctx := context.Background()

	pool, err := db.SetupDB(ctx)
	if err != nil {
		log.Fatal("Failed to connect do the db: %v", err)
	}

	defer pool.Close()
}
