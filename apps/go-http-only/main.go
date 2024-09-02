package main

import (
	"context"
	// "database/sql"
	"encoding/json"
	// "errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

func root_handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "go http only!")
}

func hello_handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello from go http only!")
}

// Data structure to hold the incoming JSON data
type MyData struct {
	Key    string  `json:"key" binding:"required"`
}

// Handler to save JSON data to the PostgreSQL database
func saveJSONHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var data MyData
	err := json.NewDecoder(r.Body).Decode(&data)
	if err != nil {
		http.Error(w, "Invalid JSON data", http.StatusBadRequest)
		return
	}

	jsonData, err := json.Marshal(data)
	if err != nil {
		http.Error(w, "Failed to encode JSON", http.StatusInternalServerError)
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	id := uuid.New()
	query := `INSERT INTO go_http_only (id, data) VALUES ($1, $2)`
	_, err = db.Exec(ctx, query, id, jsonData)
	if err != nil {
		http.Error(w, "Failed to save data", http.StatusInternalServerError)
		log.Printf("Database insert failed: %v", err)
		return
	}

	// w.WriteHeader(http.StatusCreated)
	// fmt.Fprintln(w, "Data saved successfully!")
	// Set the Content-Type header to application/json
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)

	// Return the same JSON object back to the client
	w.Write(jsonData)
}

var db *pgxpool.Pool

func main() {
	var err error

	// Set up the PostgreSQL connection
	database_url, exists := os.LookupEnv("DATABASE_URL")
	log.Printf("ENV ===>>> %v %v", database_url, exists)
	if exists == false {
		log.Fatalf("The environment variable DATABASE_URL is not set")
		// return errors.New("The environment variable DATABASE_URL is not set")
	}

	db, err = pgxpool.New(context.Background(), database_url)
	if err != nil {
		log.Fatalf("Unable to connect to database: %v", err)
	}
	defer db.Close()
	rows, err := db.Query(context.Background(), "SELECT 1")

	if err != nil {
		log.Fatalf("Unable to query database: %v", err)
	}

	fmt.Println("rows")
	fmt.Println(rows)

	mux := http.NewServeMux()
	// Add the JSON saving handler
	mux.HandleFunc("/insert", saveJSONHandler)
	// mux.HandleFunc("/", handler)
	mux.HandleFunc("/", root_handler)
	mux.HandleFunc("/hello", hello_handler)

	server := &http.Server{
		Addr:         ":8080",
		Handler:      mux,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  120 * time.Second,
	}

	// Start the server
	fmt.Println("Starting server on :8080...")
	if err := server.ListenAndServe(); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
