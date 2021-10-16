postgres:
	docker run --name postgresql -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:latest
createdb:
	docker exec -it postgresql createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgresql dropdb simple_bank

create-table:
	#create table init schema
	migrate create -ext sql -dir db/migration -seq init_schema;
	#create table add_user
	migrate create -ext sql -dir db/migration -seq add_user;

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc

