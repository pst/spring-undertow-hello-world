#
# Build container
#
FROM openjdk:8-jdk-alpine AS build

RUN apk add maven

COPY pom.xml /build/pom.xml
COPY src/ /build/src/

WORKDIR /build
RUN mvn package

#
# Final container
#
FROM openjdk:8-jdk-alpine AS prod

RUN apk --no-cache add curl

COPY --from=build /build/target/*.jar /app/app.jar

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar"]
