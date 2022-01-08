# OpenCV Alpine Docker Image for Java Applications

Run `docker pull dilhelh/java-opencv-alpine:latest`

## Example usage

``` yml
services:
  tesseract_api:
    image: dilhelh/java-opencv-alpine:latest
    container_name: tesseract_api
    volumes:
    - type: bind
      source: ./tessdata/ #Tesseract data folder (Relative or absolute file path)
      target: /usr/share/tessdata
    - type: bind
      source: ./target/tesseract-api-0.0.1-SNAPSHOT.jar #Java app that consumes Opencv native libraries
      target: /opt/tesseract-api-0.0.1-SNAPSHOT.jar
    ports:
      - 8080:8080
    command: "java -jar ./tesseract-api-0.0.1-SNAPSHOT.jar" #Command to execute the app
```
