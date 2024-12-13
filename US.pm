#include <AceButton.h>
using namespace ace_button;

#define BUTTON_PIN 2  // Push button connected to pin D2
#define BUZZER_PIN A3 // Buzzer connected to pin A3
#define TRIG_PIN A1   // Ultrasonic sensor Trig pin connected to A1
#define ECHO_PIN A2   // Ultrasonic sensor Echo pin connected to A2

AceButton button(BUTTON_PIN); // Create an AceButton instance
bool isBuzzerOn = false;      // Initial state of the buzzer

// Ultrasonic variables
int duration, distance;

// Function to toggle the buzzer state when the button is pressed
void handleEvent(AceButton* btn, uint8_t eventType, uint8_t buttonState) {
  if (eventType == AceButton::kEventPressed) {
    isBuzzerOn = !isBuzzerOn; // Toggle the buzzer state
    if (!isBuzzerOn) {
      digitalWrite(BUZZER_PIN, LOW); // Turn off the buzzer if toggled off
    }
  }
}

void setup() {
  pinMode(BUZZER_PIN, OUTPUT);  // Set the buzzer pin as output
  pinMode(TRIG_PIN, OUTPUT);    // Set the Trig pin as output
  pinMode(ECHO_PIN, INPUT);     // Set the Echo pin as input

  button.init(BUTTON_PIN);      // Initialize the button
  ButtonConfig* buttonConfig = button.getButtonConfig();
  buttonConfig->setEventHandler(handleEvent); // Attach the event handler

  Serial.begin(9600); // Initialize serial communication
}

void loop() {
  button.check(); // Continuously check button state

  if (isBuzzerOn) {
    digitalWrite(BUZZER_PIN, LOW);// Ultrasonic distance measurement
    digitalWrite(TRIG_PIN, HIGH);
    delayMicroseconds(50);
    digitalWrite(TRIG_PIN, LOW);

    duration = pulseIn(ECHO_PIN, HIGH);
    distance = (duration / 2) / 29.1;

    if (distance <= 30) { // If obstacle is detected within 30 cm
      digitalWrite(BUZZER_PIN, HIGH); // Turn on the buzzer
      delay(50); }
    
    else {
    digitalWrite(BUZZER_PIN, LOW); // Ensure buzzer remains off when toggled off
    delay(50);              
    }

    Serial.print("Distance: ");
    Serial.print(distance);
    Serial.println(" cm");
  }
}