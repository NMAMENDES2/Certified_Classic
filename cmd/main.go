package main

import (
	"context"
	"log"

	"github.com/jackc/pgx/v4"
)

type User struct {
	Username string
	Email    string
	password string
}

func main() {

	users := []User{
		{"CR7", "Ronaldo@mail.pt", "123"},
		{"Messi", "Messi@mail.ar", "123"},
		{"Lucas Claro", "LucasFutebolada@mail.pt", "123"},
	}

	db := "postgres://user:pw@localhost:5432/Certified_Classic"
	conn, err := pgx.Connect(context.Background(), db)
	if err != nil {
		log.Fatal("Unable to connect to the DB")
	}

	defer conn.Close(context.Background())

	batch := &pgx.Batch{}
	for _, user := range users {
		batch.Queue("INSERT INTO users(username, email, password_hash) VALUES ($1, $2, $3)", user.Username, user.Email, user.password)
	}

	br := conn.SendBatch(context.Background(), batch)
	defer br.Close()

	for i := 0; i < len(users); i++ {
		_, err := br.Exec()
		if err != nil {
			log.Printf("Failed to insert user %s: %v\n", users[i].Username, err)
		} else {
			log.Printf("Inserted user: %s\n", users[i].Username)
		}
	}
}
