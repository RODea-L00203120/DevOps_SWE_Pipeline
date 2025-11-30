# AlgoBench DevOps Pipeline

This repository demonstrates a demonstrative DevOps Pipeline incorporating modern tooling and practices - it incorporates a performance benchmarking application for comparing various sorting algorithms across different input sizes and data distributions. 

## Technologies

### Application Stack
- **Language:** Java 21 (Eclipse Temurin)
- **Framework:** Spring Boot 3.5.8
- **Build Tool:** Gradle 8.12.1
- **Testing:** JUnit 5.12.2

### DevOps Tools
- **Version Control:** Git 2.43.0
- **CI/CD:** GitHub Actions
- **Containerization:** 
  - Docker 28.5.1
  - Docker Compose v2.40.2
- **Container Registry:** GitHub Container Registry (GHCR)
- **Security Scanning:** Trivy Action 0.33.1 (SARIF format)

### Infrastructure
- **Cloud Platform:** AWS
  - EC2: t3.micro (Amazon Linux 2023)
  - Region: us-east-1
- **IaC:** Terraform 1.0.0+ (AWS Provider 6.23.0)
- **AWS CLI:** 2.31.18

### Monitoring
- **Metrics:** Prometheus (latest fetched)
- **Visualization:** Grafana (latest fetched)



## Architecture

``` mermaid
flowchart TB
    subgraph GH["GitHub Repository"]
        Push["Push to main"]
        
        subgraph CI["CI Pipeline"]
            Build["Build<br/>(Gradle)"]
            Test["Test<br/>(JUnit)"]
            Scan["Security Scan<br/>(Trivy)"]
            Docker["Docker Build<br/>& Push"]
            Build --> Test --> Scan --> Docker
        end
        
        subgraph Deploy["Deploy Pipeline"]
            Init["Terraform Init"]
            Plan["Terraform Plan"]
            Apply["Terraform Apply"]
            Init --> Plan --> Apply
        end
    end
    
    subgraph GHCR["GitHub Container Registry"]
        Image["Docker Image"]
    end
    
    subgraph AWS["AWS EC2"]
        subgraph Containers["Docker Containers"]
            App["Algobench<br/>:8080"]
            Prom["Prometheus<br/>:9090"]
            Graf["Grafana<br/>:3000"]
        end
    end
    
    Push --> Build
    Push --> Init
    Docker --> Image
    Image -->|"docker pull"| App
    Apply -->|"provisions"| AWS
    App --> Prom --> Graf

    style GH fill:#f5f5f5,stroke:#333
    style CI fill:#dbeafe,stroke:#3b82f6
    style Deploy fill:#fef3c7,stroke:#f59e0b
    style GHCR fill:#e9d5ff,stroke:#9333ea
    style AWS fill:#dcfce7,stroke:#22c55e
    style Containers fill:#bbf7d0,stroke:#22c55e
```
## Project Structure

The project follows following structure:

```
AlgoBench/
|   .dockerignore
|   .gitattributes
|   .gitignore
|   build.gradle.kts
|   docker-compose.yml
|   Dockerfile
|   gradle.properties
|   gradlew
|   gradlew.bat
|   LICENSE
|   README.md
|   settings.gradle
|
+---.devcontainer
|       devcontainer.json
|
+---.github
|   \---workflows
|           ci.yml
|           deploy.yml
|
+---gradle
|   |   libs.versions.toml
|   |
|   \---wrapper
|           gradle-wrapper.jar
|           gradle-wrapper.properties
|
+---monitoring
|       docker-compose.yml
|       prometheus.yml
|
+---src
|   +---main
|   |   +---java
|   |   |   \---ie
|   |   |       \---ronanodea
|   |   |           \---algobench
|   |   |               |   BenchmarkConfig.java
|   |   |               |   Benchmarker.java
|   |   |               |   BenchmarkResultsPrinter.java
|   |   |               |   BenchmarkRunner.java
|   |   |               |   BubbleSort.java
|   |   |               |   BucketSort.java
|   |   |               |   CommandLineParser.java
|   |   |               |   CSVExporter.java
|   |   |               |   InsertionSort.java
|   |   |               |   Main.java
|   |   |               |   MergeSort.java
|   |   |               |   SelectionSort.java
|   |   |               |
|   |   |               \---controller
|   |   |                       BenchmarkController.java
|   |   |
|   |   \---resources
|   |       |   application.properties
|   |       |
|   |       \---static
|   |               index.html
|   |
|   \---test
|       \---java
|           \---ie
|               \---ronanodea
|                   \---algobench
|                           BubbleSortTest.java
|                           BucketSortTest.java
|                           CommandLineParserTest.java
|                           InsertationSortTest.java
|                           MergeSortTest.java
|                           SelectionSortTest.java
|
\---terraform
        .gitignore
        ec2.tf
        main.tf
        outputs.tf
        security-group.tf
        user-data.sh
        variables.tf
```
_______________________________________

## Pipeline Phase 1: Version Control

**Implementation:**
- Cloned my original Algobench repo: https://github.com/RonanChrisODea/Algorithm-Benchmarking-Project to Pipeline repository
- Created GitHub repository with proper `.gitignore` for Java/Gradle projects
- Implemented feature branch workflow

## Pipeline Phase 2: Application Finalisation

https://github.com/RODea-L00203120/DevOps_SWE_Pipeline/tree/feature/rest-api

Added a Spring Boot REST API, providing:
- Web-based landing page
- REST endpoints for algorithm operations
- Actuator endpoints for health checks and metrics
- Prometheus metrics endpoint for monitoring         integration

## Pipeline Phase 3: Automated Builds & Testing

- Gradle build system
- JUnit 5 test framework

To continue