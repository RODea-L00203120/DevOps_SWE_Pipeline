plugins {
    id("java")
    id("application")
    // Spring Boot 3.5.8 is the latest stable version and implicitly manages JUnit versions
    id("org.springframework.boot") version "3.5.8"
    id("io.spring.dependency-management") version "1.1.4"
}

group = "ie.ronanodea"
version = "1.0.0"

repositories {
    mavenCentral()
}

java {
    // Using Java 21, which is compatible with Spring Boot 3.5.8
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(21))
    }
}

dependencies {
    // Application Dependencies
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    
   
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.junit.jupiter:junit-jupiter")
}

application {
    mainClass.set("ie.ronanodea.algobench.Main")
}

tasks.test {
    // Required for JUnit 5 (Jupiter)
    useJUnitPlatform()
}

tasks.named<org.springframework.boot.gradle.tasks.bundling.BootJar>("bootJar") {
    archiveFileName.set("algobench.jar")
}