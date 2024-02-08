FROM maven:3.8-openjdk-11 AS build
WORKDIR /src
COPY . .
RUN mvn -B -q package -DskipTests

FROM adoptopenjdk:11-jre-hotspot
WORKDIR /app
COPY --from=build /src/export-cli/target/export-cli-*.jar /app/export-cli.jar
COPY --from=build /root/.m2/repository /root/.m2/repository
CMD ["java", "-cp", "/app/export-cli.jar", "com.fleetwise.billing.cli.ExportMain"]
