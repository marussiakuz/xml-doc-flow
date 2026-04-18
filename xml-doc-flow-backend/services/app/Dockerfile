FROM maven:3.9.11-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml /app/pom.xml
COPY services/pom.xml /app/services/pom.xml
COPY services/app/pom.xml /app/services/app/pom.xml

COPY services /app/services

RUN mvn -pl services/app -am -DskipTests package

FROM eclipse-temurin:17-jre

WORKDIR /app
COPY --from=build /app/services/app/target/*.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/app.jar"]

