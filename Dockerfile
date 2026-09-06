FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

#copy pom.xml
COPY pom.xml .
COPY src ./src

# Build the jar file (we skip tests here because Jenkins will run them earlier)
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Run the application
# ==========================================
FROM eclipse-temurin:21-jre
WORKDIR /app

# Expose port 9090 since you configured your app to use it
EXPOSE 9090

COPY --from=build /app/target/*-SNAPSHOT.jar app.jar

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]