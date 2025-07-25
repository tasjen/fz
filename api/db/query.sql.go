// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0
// source: query.sql

package db

import (
	"context"

	"github.com/jackc/pgx/v5/pgtype"
)

const createUser = `-- name: CreateUser :exec
INSERT INTO users (username, password, email) VALUES ($1, $2, $3)
`

type CreateUserParams struct {
	Username string
	Password string
	Email    *string
}

func (q *Queries) CreateUser(ctx context.Context, arg CreateUserParams) error {
	_, err := q.db.Exec(ctx, createUser, arg.Username, arg.Password, arg.Email)
	return err
}

const getTemple = `-- name: GetTemple :one
SELECT id, name_th, name_en, location, address_th, address_en, contact_phone, founded_on FROM temples
WHERE id = $1 LIMIT 1
`

func (q *Queries) GetTemple(ctx context.Context, id pgtype.UUID) (Temple, error) {
	row := q.db.QueryRow(ctx, getTemple, id)
	var i Temple
	err := row.Scan(
		&i.ID,
		&i.NameTh,
		&i.NameEn,
		&i.Location,
		&i.AddressTh,
		&i.AddressEn,
		&i.ContactPhone,
		&i.FoundedOn,
	)
	return i, err
}

const listTemples = `-- name: ListTemples :many
SELECT id, name_th, name_en, location, address_th, address_en, contact_phone, founded_on FROM temples
ORDER BY name_th ASC
`

func (q *Queries) ListTemples(ctx context.Context) ([]Temple, error) {
	rows, err := q.db.Query(ctx, listTemples)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []Temple
	for rows.Next() {
		var i Temple
		if err := rows.Scan(
			&i.ID,
			&i.NameTh,
			&i.NameEn,
			&i.Location,
			&i.AddressTh,
			&i.AddressEn,
			&i.ContactPhone,
			&i.FoundedOn,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
