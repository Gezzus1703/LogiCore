
# LogiCore – Enterprise Logistics Data Platform

🚧 **Work in Progress**

LogiCore is a portfolio project focused on building an end-to-end data platform for a fictional logistics company, **NorthStar Logistics Group**.

The goal is to simulate a realistic business environment and build a data pipeline covering data ingestion, storage, processing, transformation and reporting.

## Architecture

The target architecture:

```text
SQL Server
    ↓
Azure Data Factory
    ↓
Azure Data Lake Storage Gen2
    ↓
Azure Databricks
    ↓
PySpark + Delta Lake
    ↓
dbt
    ↓
Power BI
```

*The architecture represents the project roadmap. Components will be implemented incrementally.*

## Current Progress

### Day 1 – Database Foundations

- [x] SQL Server 2022 running in Docker
- [x] Initial ERP database structure (17 tables)
- [x] Relational model with primary and foreign keys
- [x] Temporal Tables for historical data tracking
- [x] SQL Database Project with DACPAC build
- [x] Git and GitHub repository setup

### Current Focus

Preparing the source ERP database and building realistic sample logistics data.

## Tech Stack

- **Database:** SQL Server 2022
- **Infrastructure:** Docker
- **Cloud:** Microsoft Azure
- **Orchestration:** Azure Data Factory
- **Storage:** Azure Data Lake Storage Gen2
- **Processing:** Azure Databricks, PySpark
- **Data Format:** Delta Lake
- **Transformation:** dbt
- **Reporting:** Power BI
- **Version Control:** Git, GitHub

## Project Status

This project is being developed step by step. The progress section will be updated as new components are implemented.

The focus is on practical engineering, architectural decisions and understanding how modern data platforms work in a real business environment.

**Follow the repository to see how LogiCore evolves.** 🚀
