# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11 AS build

WORKDIR /app

# Copy the pom.xml file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the application code and build the application
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Create the final image
FROM openjdk:11-jre-slim

WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Add a non-root user for running the application
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser 

USER appuser

# Expose the application port
EXPOSE 8080

# Define environment variables securely
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"
ENV APP_NAME="SpringBootApp"

# Run the application as a non-root user
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]