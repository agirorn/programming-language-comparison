package main

import (
	"database/sql"
	"database/sql/driver"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	_ "github.com/lib/pq"
	// "github.com/lib/pq"
)

type album struct {
	ID     string  `json:"id"`
	Title  string  `json:"title"`
	Artist string  `json:"artist"`
	Price  float64 `json:"price"`
}

var db *sql.DB

func main() {
	if err := run(); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}

func run() error {
	// err := something()
	// if err != nil {
	// 	return err
	// }
	// // etc

	database_url, exists := os.LookupEnv("DATABASE_URL")
	log.Printf("ENV ===>>> %v %v", database_url, exists)
	if exists == false {
		return errors.New("The environment variable DATABASE_URL is not set")
	}

	var err error
	// db, err = sql.Open("postgres", "postgres://db_user:db_pass@postgres/the_database?sslmode=disable")
	db, err = sql.Open("postgres", database_url)
	db.SetMaxOpenConns(10)
	if err != nil {
		log.Fatal(err)
	}

	router := gin.Default()
	router.GET("/", getRoot)
	router.GET("/hello", getHello)
	router.POST("/insert", postInsert)
	router.GET("/count", getCount)
	router.GET("/albums", getAlbums)
	router.POST("/albums", createAlbum)

	router.Run(":8080")
	return errors.New("Exit time")
}

func getRoot(c *gin.Context) {
	c.Header("Content-Type", "application/json")
	c.IndentedJSON(http.StatusOK, "Root")
}

func getHello(c *gin.Context) {
	c.Header("Content-Type", "application/json")
	c.IndentedJSON(http.StatusOK, "Hello from go-http-router")
}

func getAlbums(c *gin.Context) {
	c.Header("Content-Type", "application/json")

	rows, err := db.Query("SELECT id, title, artist, price FROM albums")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	var albums []album
	for rows.Next() {
		var a album
		err := rows.Scan(&a.ID, &a.Title, &a.Artist, &a.Price)
		if err != nil {
			log.Fatal(err)
		}
		albums = append(albums, a)
	}
	err = rows.Err()
	if err != nil {
		log.Fatal(err)
	}

	c.IndentedJSON(http.StatusOK, albums)
}

// type album struct {
// 	ID     string  `json:"id"`
// 	Title  string  `json:"title"`
// 	Artist string  `json:"artist"`
// 	Price  float64 `json:"price"`
// }

func createAlbum(c *gin.Context) {

	var awesomeAlbum album
	if err := c.BindJSON(&awesomeAlbum); err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	stmt, err := db.Prepare("INSERT INTO albums (id, title, artist, price) VALUES ($1, $2, $3, $4)")
	if err != nil {
		log.Fatal(err)
	}
	defer stmt.Close()

	if _, err := stmt.Exec(awesomeAlbum.ID, awesomeAlbum.Title, awesomeAlbum.Artist, awesomeAlbum.Price); err != nil {
		log.Fatal(err)
	}

	c.JSON(http.StatusCreated, awesomeAlbum)
}

type insert struct {
	Key    string  `json:"key" binding:"required"`
}

// Make the Attrs struct implement the driver.Valuer interface. This method
// simply returns the JSON-encoded representation of the struct.
func (a insert) Value() (driver.Value, error) {
	return json.Marshal(a)
}

func getCount(c *gin.Context) {
	c.Header("Content-Type", "application/json")

	rows, err := db.Query("SELECT count(*) as count from go_http_router")
	if err != nil {
		c.AbortWithStatusJSON(http.StatusBadRequest, err.Error())
	}
	defer rows.Close()

	var count int
	for rows.Next() {
		if err := rows.Scan(&count); err != nil {
			log.Fatal(err)
		}
	}
	c.IndentedJSON(http.StatusOK, count)
}

func postInsert(c *gin.Context) {
	fmt.Fprintf(os.Stderr, "insert\n")
	var data insert
	if err := c.ShouldBindJSON(&data); err != nil {
		fmt.Fprintf(os.Stderr, "in error\n")
		fmt.Fprintf(os.Stderr, "error %v\n", err)
		// c.AbortWithStatusJSON(
		// 	http.StatusBadRequest, gin.H{"error": "Invalid request payload"})

		c.AbortWithStatusJSON(http.StatusBadRequest, err.Error())
		return
	}
	fmt.Fprintf(os.Stderr, "HERE \n")

	id := uuid.New()
	fmt.Fprintf(os.Stderr, "id => %v\n", id)

	stmt, err := db.Prepare("INSERT INTO go_http_router  (id, data) VALUES ($1, $2)")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Fatal error=> %v\n", err.Error())
		c.AbortWithStatusJSON(http.StatusBadRequest, err.Error())
	}
	defer stmt.Close()

	if _, err := stmt.Exec(id, data); err != nil {
		fmt.Fprintf(os.Stderr, "Fatal error=> %v\n", err.Error())
		c.AbortWithStatusJSON(http.StatusBadRequest, err.Error())
	}

	c.JSON(http.StatusCreated, data)
}
