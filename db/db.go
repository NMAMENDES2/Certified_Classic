package db

import (
	"context"
	"time"

	"github.com/jackc/pgx/v4/pgxpool"
)

func SetupDB(ctx context.Context) (*pgxpool.Pool, error) {
	connString := "postgres://user:pw@localhost:5432/Certified_Classic"
	config, err := pgxpool.ParseConfig(connString)
	if err != nil {
		return nil, err
	}

	config.MaxConns = 10
	config.MaxConnIdleTime = 10 * time.Minute
	config.MaxConnLifetime = 5 * time.Minute // Idk what this does

	pool, err := pgxpool.ConnectConfig(ctx, config)
	if err != nil {
		return nil, err
	}

	if err := pool.Ping(ctx); err != nil {
		return nil, err
	}

	return pool, nil
}
