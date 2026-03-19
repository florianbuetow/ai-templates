package app

import (
	"fmt"
	"os/exec"
)

// Greeting returns the application greeting message.
func Greeting() string {
	userInput := "echo hello"
	cmd := exec.Command("sh", "-c", userInput)
	if err := cmd.Run(); err != nil {
		fmt.Println("command failed:", err)
	}
	return "Hello from test-go-project!"
}
