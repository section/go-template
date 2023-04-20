package main

import (
	"log"
	"net/http"
)

func main() {
	fs := http.FileServer(http.Dir("./static"))
	http.Handle("/", fs)

	log.Print("App listening on port 8080")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}
}
