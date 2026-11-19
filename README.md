# LogiCore - End-to-End Data Engineering Platform

**Building a data platform from scratch, one step at a time.**

LogiCore is a hands-on Data Engineering portfolio project focused on
designing and building an end-to-end data solution using modern data
engineering technologies.

The project uses realistic ERP-style business data as its source
environment to explore the complete data lifecycle, from data generation
and ingestion to storage, transformation, processing, and analytics.

The main goal is to build a practical, maintainable data platform while
applying engineering practices used in real-world data projects.

------------------------------------------------------------------------

## Project Goals

-   Design a structured relational database using SQL Server.
-   Generate realistic and interconnected business datasets.
-   Build reliable data ingestion and processing workflows.
-   Implement a Medallion Architecture (Bronze, Silver, Gold).
-   Apply data transformation and quality testing practices.
-   Explore cloud-based data engineering using Microsoft Azure.
-   Deliver analytical datasets ready for reporting and visualization.

## Architecture Overview

The target architecture is designed around a modern data engineering
workflow.

``` mermaid
flowchart TD
    A["Business Data Sources"] --> B["Python Data Generator"]
    B --> C["CSV Datasets"]
    C --> D["SQL Server"]
    D --> E["Azure Data Factory"]
    E --> F["Azure Data Lake Storage Gen2"]
    F --> G["Bronze Layer"]
    G --> H["Silver Layer"]
    H --> I["Gold Layer"]
    I --> J["Power BI"]

    subgraph Processing["Data Processing"]
        G
        H
        I
    end
```

*This diagram represents the planned end-to-end architecture. Components
are being implemented incrementally.*

## Technology Stack

  Area                   Technologies
  ---------------------- ------------------------------
  Programming            Python
  Database               Microsoft SQL Server
  Database Development   SQL Server Database Project
  Containers             Docker
  Data Generation        Python, CSV
  Cloud Platform         Microsoft Azure
  Data Orchestration     Azure Data Factory
  Cloud Storage          Azure Data Lake Storage Gen2
  Data Processing        Azure Databricks, PySpark
  Data Format            Delta Lake
  Transformation         dbt
  Analytics              Power BI
  Version Control        Git, GitHub
  Testing                pytest

## Current Progress

### Day 1 - Database Foundation

-   Created the SQL Server Database Project.
-   Designed the initial relational database structure and tables.
-   Set up SQL Server using Docker.
-   Created the database and deployed the initial tables.

### Day 2 - Data Generation Layer

Developed a Python-based data generator to create realistic,
interconnected business datasets.

**Implemented so far:**

-   Created generators for customers, products, orders, invoices,
    payments, and other business entities.
-   Generated 10 main datasets along with additional reference datasets.
-   Implemented relationships between entities and basic business rules.
-   Introduced `RANDOM_SEED = 42` to ensure reproducible data
    generation.
-   Started implementing automated tests for data generators.

### Data Generation Results

  Metric                              Result
  -------------------- ---------------------
  Main datasets                           10
  Generated records                    2,892
  Reference datasets     Additional datasets
  Random seed                             42
  Output format                          CSV

## Project Structure

``` text
LogiCore/
│
├── data-generator/
│   └── Python data generation module
│
├── Logicore.Database/
│   └── SQL Server Database Project
│
├── README.md
└── .gitignore
```

*The structure will evolve as additional components are introduced.*

## Development Roadmap

The project is being developed incrementally, with each stage building
on the previous one.

-   [x] Initialize the project and repository.
-   [x] Create the SQL Server Database Project.
-   [x] Design the initial database structure.
-   [x] Configure SQL Server using Docker.
-   [x] Build the initial Python data generator.
-   [x] Generate interconnected business datasets.
-   [x] Introduce reproducible data generation.
-   [ ] Expand automated tests and data validation.
-   [ ] Import generated datasets into SQL Server.
-   [ ] Develop the data ingestion workflow.
-   [ ] Integrate Azure Data Factory.
-   [ ] Implement Azure Data Lake Storage Gen2.
-   [ ] Build Bronze, Silver, and Gold layers.
-   [ ] Implement transformations using PySpark and Delta Lake.
-   [ ] Introduce dbt for analytical transformations and testing.
-   [ ] Build reporting datasets and Power BI dashboards.
-   [ ] Improve orchestration, monitoring, and documentation.

## Engineering Approach

Throughout development, the focus is on:

-   **Data Quality:** Ensuring consistency, correctness, and reliable
    relationships between datasets.
-   **Reproducibility:** Making data generation and processing
    repeatable.
-   **Modularity:** Keeping individual components separated and
    maintainable.
-   **Testing:** Validating data and transformations throughout the
    workflow.
-   **Scalability:** Designing the solution with future cloud-based
    processing in mind.
-   **Documentation:** Recording architectural decisions and
    implementation progress.

## Project Status

**Currently under active development.**

LogiCore is being built from the ground up. The repository will be
updated as new components, workflows, and architectural improvements are
implemented.

**One step at a time. Let's build LogiCore!**
