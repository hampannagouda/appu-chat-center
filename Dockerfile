# Stage 1: Build the application
FROM maven:3.8.6-openjdk-8-slim AS build
WORKDIR /app

# Copy the pom.xml file
COPY pom.xml .

# Download all required dependencies into one layer
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM tomcat:9.0-jdk8-corretto
# Set the working directory to Tomcat's webapps directory
WORKDIR /usr/local/tomcat/webapps/

# Clean up default Tomcat applications
RUN rm -rf *

# Copy the generated WAR file from the build stage
COPY --from=build /app/target/appu-chat-center.war ./ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
