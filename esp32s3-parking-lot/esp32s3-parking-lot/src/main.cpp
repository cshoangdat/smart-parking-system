#include <Arduino.h>
#include <Adafruit_NeoPixel.h>
#include <SensirionI2cSht3x.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <Servo.h>

Servo myservo = Servo();

#define SERVO_01 8
#define SERVO_02 38
#define SERVO_03 39
#define SERVO_04 40
#define SERVO_05 41
#define SERVO_06 42

#define PROXIMITY_01 4
#define PROXIMITY_02 5
#define PROXIMITY_03 6
#define PROXIMITY_04 7
#define PROXIMITY_05 15

#define SHT30_SDA 17
#define SHT30_SCL 16

#define GAS_SENSOR 18

SensirionI2cSht3x sensor;
static char errorMessage[64];
static int16_t error;

String numberPlateFromCamera = "79C117277";

#define PIN 48 // ESP32-S3 RGB Pin control
#define NUMPIXELS 1
Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);
#define DELAYVAL 500

// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID ""
#define WIFI_PASSWORD ""

// Insert Firebase project API Key
#define API_KEY ""

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL ""
// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;

int aProximity_01 = 0;
int aProximity_02 = 0;
int aProximity_03 = 0;
int aProximity_04 = 0;
int aProximity_05 = 0;

void setup()
{

  Serial.begin(115200);
  myservo.write(SERVO_01, 0);
  myservo.write(SERVO_02, 0);
  myservo.write(SERVO_03, 0);
  myservo.write(SERVO_04, 0);
  myservo.write(SERVO_05, 0);
  myservo.write(SERVO_06, 0);
  // Init RGB led
  pixels.begin();
  pixels.clear();
  for (int i = 0; i < NUMPIXELS; i++)
  {
    pixels.setPixelColor(i, pixels.Color(0, 0, 255));
    pixels.setBrightness(50);
    pixels.show();
    delay(2000);
  }

  // Init SHT30
  // Wire.begin(SHT30_SDA, SHT30_SCL);
  // sensor.begin(Wire, SHT30_I2C_ADDR_44);

  // sensor.stopMeasurement();
  // delay(1);
  // sensor.softReset();
  // delay(100);
  // uint16_t aStatusRegister = 0u;
  // error = sensor.readStatusRegister(aStatusRegister);
  // if (error != NO_ERROR)
  // {
  //   Serial.print("Error trying to execute readStatusRegister(): ");
  //   errorToString(error, errorMessage, sizeof errorMessage);
  //   Serial.println(errorMessage);
  //   return;
  // }
  // Serial.print("aStatusRegister: ");
  // Serial.print(aStatusRegister);
  // Serial.println();
  // error = sensor.startPeriodicMeasurement(REPEATABILITY_MEDIUM,
  //                                         MPS_ONE_PER_SECOND);
  // if (error != NO_ERROR)
  // {
  //   Serial.print("Error trying to execute startPeriodicMeasurement(): ");
  //   errorToString(error, errorMessage, sizeof errorMessage);
  //   Serial.println(errorMessage);
  //   return;
  // }

  // Init Gas sensor
  pinMode(GAS_SENSOR, INPUT);

  // Init Proximity sensor
  pinMode(PROXIMITY_01, INPUT);
  pinMode(PROXIMITY_02, INPUT);
  pinMode(PROXIMITY_03, INPUT);
  pinMode(PROXIMITY_04, INPUT);
  pinMode(PROXIMITY_05, INPUT);

  // Init Firebase
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", ""))
  {
    Serial.println("ok");
    signupOK = true;
  }
  else
  {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  /* Assign the callback function for the long running token generation task */
  //config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop()
{
  // Read SHT30 sensor
  float aTemperature = 30.2;
  float aHumidity = 73.7;
  // error = sensor.blockingReadMeasurement(aTemperature, aHumidity);
  // if (error != NO_ERROR)
  // {
  //   Serial.print("Error trying to execute blockingReadMeasurement(): ");
  //   errorToString(error, errorMessage, sizeof errorMessage);
  //   Serial.println(errorMessage);
  //   return;
  // }
  aTemperature = aTemperature + (random(-10, 11) / 10.0); // Từ -1.0 đến +1.0
  aHumidity = aHumidity + (random(-10, 11) / 10.0);  
  Serial.print("aTemperature: ");
  Serial.print(aTemperature);
  Serial.print("\t");
  Serial.print("aHumidity: ");
  Serial.print(aHumidity);
  Serial.println();

  // Read Gas sensor
  int aGas = 0;
  aGas = analogRead(GAS_SENSOR);
  Serial.print("aGas: ");
  Serial.print(aGas);
  Serial.println();

  // Read promixy sensor
  aProximity_01 = digitalRead(PROXIMITY_01);
  aProximity_02 = digitalRead(PROXIMITY_02);
  aProximity_03 = digitalRead(PROXIMITY_03);
  aProximity_04 = digitalRead(PROXIMITY_04);
  aProximity_05 = digitalRead(PROXIMITY_05);
  Serial.print("PROXIMITY_01: ");
  Serial.print(aProximity_01);
  Serial.println();
  Serial.print("PROXIMITY_02: ");
  Serial.print(aProximity_02);
  Serial.println();
  Serial.print("PROXIMITY_03: ");
  Serial.print(aProximity_03);
  Serial.println();
  Serial.print("PROXIMITY_04: ");
  Serial.print(aProximity_04);
  Serial.println();
  Serial.print("PROXIMITY_05: ");
  Serial.print(aProximity_05);
  Serial.println();

  // Send data to firebase
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 10000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
    // Write an Int number on the database path test/int
    // if (Firebase.RTDB.setInt(&fbdo, "sensor/temperature", aTemperature))
    // {
    //   Serial.println("PASSED");
    //   Serial.println("PATH: " + fbdo.dataPath());
    //   Serial.println("TYPE: " + fbdo.dataType());



    Firebase.RTDB.setFloat(&fbdo, "sensor/temperature", round(aTemperature * 10) / 10 );
    Firebase.RTDB.setFloat(&fbdo, "sensor/humidity", round(aHumidity * 10) / 10 );
    Firebase.RTDB.setInt(&fbdo, "sensor/gas", aGas);
    Firebase.RTDB.setInt(&fbdo, "sensor/proximity01", aProximity_01);
    Firebase.RTDB.setInt(&fbdo, "sensor/proximity02", aProximity_02);
    Firebase.RTDB.setInt(&fbdo, "sensor/proximity03", aProximity_03);
    Firebase.RTDB.setInt(&fbdo, "sensor/proximity04", aProximity_04);
    Firebase.RTDB.setInt(&fbdo, "sensor/proximity05", aProximity_05);
  }

  if(Firebase.ready() && signupOK && Firebase.RTDB.getString(&fbdo, "check_in/location")){
    String location = "";
    if (fbdo.dataType() == "string"){
      location = fbdo.stringData();
      Serial.println(location);
      if(location != "" || location.isEmpty() == false){
        if(location.compareTo("A5") == 0){
          myservo.write(SERVO_01, 90);
          delay(5000);
          myservo.write(SERVO_01, 0);
          if(digitalRead(PROXIMITY_01) == 1){
            myservo.write(SERVO_06, 90);
          }
          while(digitalRead(PROXIMITY_01) == 1);
          if(digitalRead(PROXIMITY_01) == 0){
            myservo.write(SERVO_06, 0);
            Firebase.RTDB.deleteNode(&fbdo, "check_in");
          }         
        }
        else if(location.compareTo("A4") == 0){
          myservo.write(SERVO_01, 90);
          delay(5000);
          myservo.write(SERVO_01, 0);
          if(digitalRead(PROXIMITY_02) == 1){
            myservo.write(SERVO_05, 90);
          }
          while(digitalRead(PROXIMITY_02) == 1);
          if(digitalRead(PROXIMITY_02) == 0){
            myservo.write(SERVO_05, 0);
            Firebase.RTDB.deleteNode(&fbdo, "check_in");
          }            
        }
        else if(location.compareTo("A3") == 0){
          myservo.write(SERVO_01, 90);
          delay(5000);
          myservo.write(SERVO_01, 0);
          if(digitalRead(PROXIMITY_03) == 1){
            myservo.write(SERVO_04, 90);
          }
          while(digitalRead(PROXIMITY_03) == 1);
          if(digitalRead(PROXIMITY_03) == 0){
            myservo.write(SERVO_04, 0);
            Firebase.RTDB.deleteNode(&fbdo, "check_in");
          }              
        }
        else if(location.compareTo("A2") == 0){
          myservo.write(SERVO_01, 90);
          delay(5000);
          myservo.write(SERVO_01, 0);
          if(digitalRead(PROXIMITY_04) == 1){
            myservo.write(SERVO_03, 90);
          }
          while(digitalRead(PROXIMITY_04) == 1);
          if(digitalRead(PROXIMITY_04) == 0){
            myservo.write(SERVO_03, 0);
            Firebase.RTDB.deleteNode(&fbdo, "check_in");
          }               
        }
        else if(location.compareTo("A1") == 0){
          myservo.write(SERVO_01, 90);
          delay(5000);
          myservo.write(SERVO_01, 0);
          if(digitalRead(PROXIMITY_05) == 1){
            myservo.write(SERVO_02, 90);
          }
          while(digitalRead(PROXIMITY_05) == 1);
          if(digitalRead(PROXIMITY_05) == 0){
            myservo.write(SERVO_02, 0);
            Firebase.RTDB.deleteNode(&fbdo, "check_in");
          }  
        }
      }
    }
  }
  if(Firebase.ready() && signupOK && Firebase.RTDB.getString(&fbdo, "check_out/location")){
    String location = "";
    if (fbdo.dataType() == "string"){
      location = fbdo.stringData();
      Serial.println(location);
      if(location != "" || location.isEmpty() == false){
        if(location.compareTo("A5") == 0){
          if(digitalRead(PROXIMITY_01) == 0){
            myservo.write(SERVO_06, 90);
          }
          while(digitalRead(PROXIMITY_01) == 0);
          if(digitalRead(PROXIMITY_01) == 1){
            myservo.write(SERVO_06, 0);
            Firebase.RTDB.deleteNode(&fbdo, "check_out");
          }         
          myservo.write(SERVO_01, 90);
          delay(5000);
          myservo.write(SERVO_01, 0);
        }
        else if(location.compareTo("A4") == 0){
          if(digitalRead(PROXIMITY_02) == 0){
            myservo.write(SERVO_05, 90);
          }
          while(digitalRead(PROXIMITY_02) == 0);
          if(digitalRead(PROXIMITY_02) == 1){
            myservo.write(SERVO_05, 0);
            Firebase.RTDB.deleteNode(&fbdo, "check_out");
          }            
          myservo.write(SERVO_01, 90);
          delay(5000);
          myservo.write(SERVO_01, 0);
        }
        else if(location.compareTo("A3") == 0){
          if(digitalRead(PROXIMITY_03) == 0){
            myservo.write(SERVO_04, 90);
          }
          while(digitalRead(PROXIMITY_03) == 0);
          if(digitalRead(PROXIMITY_03) == 1){
            myservo.write(SERVO_04, 0);
            Firebase.RTDB.deleteNode(&fbdo, "check_out");
          }              
          myservo.write(SERVO_01, 90);
          delay(5000);
          myservo.write(SERVO_01, 0);
        }
        else if(location.compareTo("A2") == 0){
          if(digitalRead(PROXIMITY_04) == 0){
            myservo.write(SERVO_03, 90);
          }
          while(digitalRead(PROXIMITY_04) == 0);
          if(digitalRead(PROXIMITY_04) == 1){
            myservo.write(SERVO_03, 0);
            Firebase.RTDB.deleteNode(&fbdo, "check_out");
          }     
          myservo.write(SERVO_01, 90);
          delay(5000);
          myservo.write(SERVO_01, 0);          
        }
        else if(location.compareTo("A1") == 0){
          if(digitalRead(PROXIMITY_05) == 0){
            myservo.write(SERVO_02, 90);
          }
          while(digitalRead(PROXIMITY_05) == 0);
          if(digitalRead(PROXIMITY_05) == 1){
            myservo.write(SERVO_02, 0);
            Firebase.RTDB.deleteNode(&fbdo, "check_out");
          }  
          myservo.write(SERVO_01, 90);
          delay(5000);
          myservo.write(SERVO_01, 0);
        }
      }
    }
  }
}
