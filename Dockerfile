FROM openjdk:11-jdk-slim
ARG JAR_FILE=target/*.jar
COPY  app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
