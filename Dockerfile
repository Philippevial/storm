FROM maven:3.8.4-openjdk-17-slim as build
COPY ./ /src
RUN mvn -f /src/pom.xml clean package

FROM eclipse-temurin:19-jre-alpine
COPY --from=build /src/target/modules /app/modules
COPY --from=build /src/target/storm.jar /app/storm.jar
RUN mkdir /webroot
ENTRYPOINT ["java","--module-path","app/storm.jar:app/modules","-m","org.fungover.storm/org.fungover.storm.server.Server"]
