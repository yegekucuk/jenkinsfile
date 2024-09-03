FROM openjdk:latest

WORKDIR /app

COPY HelloWorld.java /app/

CMD java HelloWorld.java
