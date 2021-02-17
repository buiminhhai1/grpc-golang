gen:
	protoc --proto_path=proto --go_out=plugins=grpc:pb --go_opt=paths=source_relative proto/*.proto

gen-gateway:
	protoc -I ./proto \
  --go_out=plugins=grpc:pb --go_opt paths=source_relative \
  --grpc-gateway_out ./pb --grpc-gateway_opt paths=source_relative \
	--openapiv2_out swagger \
	--openapiv2_opt logtostderr=true \
	--openapiv2_opt use_go_templates=true \
  ./proto/*.proto

clean:
	rm -rf pb/*.go pb/google

server1:
	go run cmd/server/main.go -port 50051

server2:
	go run cmd/server/main.go -port 50052

server1-tls:
	go run cmd/server/main.go -port 50051 -tls

server2-tls:
	go run cmd/server/main.go -port 50052 -tls

server:
	go run cmd/server/main.go -port 8080

server-tls:
	go run cmd/server/main.go -port 8080 -tls

rest:
	go run cmd/server/main.go -port 8081 -type rest -endpoint 0.0.0.0:8080

rest-tls:
	go run cmd/server/main.go -port 8081 -tls -type rest -endpoint 0.0.0.0:8080

client:
	go run cmd/client/main.go -address 0.0.0.0:8080

client-tls:
	go run cmd/client/main.go -address 0.0.0.0:8080 -tls

test:
	go test -cover -race ./...

install: go mod tidy

cert:
	cd cert; bash ./gen.sh; cd ..

.PHONY: gen clean server client test install cert