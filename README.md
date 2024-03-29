# cloud-tek/templates

## Gettings started

```bash
# Install the 'dotnet new' templates
./Install-Templates.ps1
```
## Templates

This repository contains a selection of Hive service templates

### hive-job

> **Description**
>
> The `hive-job` is a one-time fire & forget service which is intended to start, do it's work and shut down. Ideal for k8s cronjobs scenario(s).

**Service creation:**
```bash
dotnet new hive-job -pr <ProjectName> -svc <ServiceName> --solution (optional) 
```

### hive-microservice

> **Description**
>
> The `hive-microservice` is a long-running background processor which is not exposing any API endpoints apart from standard `/status` endpoints. It's primary uses are:
> - Task scheduling
> - Async message processing

**Service creation:**
```bash
dotnet new hive-microservice -pr <ProjectName> -svc <ServiceName> --solution (optional) 
```

### hive-microservice-api

> **Description**
>
> The `hive-microservice-api` is a long-running REST-ful service, which uses Controllers to handle incoming HTTP requests

**Service creation:**
```bash
dotnet new hive-microservice-api -pr <ProjectName> -svc <ServiceName> --solution (optional) 
```

### hive-microservice-minimal-api

> **Description**
>
> The `hive-microservice-minimal-api` is a long-running REST-ful service, which uses minimal APIs to handle incoming HTTP requests

**Service creation:**
```bash
dotnet new hive-microservice-minimal-api -pr <ProjectName> -svc <ServiceName> --solution (optional) 
```

### hive-microservice-graphql-api

> **Description**
>
> The `hive-microservice-graphql-api` is a long-running GraphQL service, which uses [HotChocolate](https://chillicream.com/docs/hotchocolate) to handle GraphQL requests. 
>
> Primary uses:
> - API gateway
> - BFF (backend for frontend)

**Service creation:**
```bash
dotnet new hive-microservice-graphql-api -pr <ProjectName> -svc <ServiceName> --solution (optional) 
```

### hive-microservice-grpc-api

> **Description**
>
> The `hive-microservice-grpc-api` is a long-running gRPC service, which uses ProtoBuf to handle gRPC requests and `.proto` files to model the API and DTO(s)

**Service creation:**
```bash
dotnet new hive-microservice-grpc-api -pr <ProjectName> -svc <ServiceName> --solution (optional) 
```

### hive-microservice-minimal-grpc-api

> **Description**
>
> The `hive-microservice-minimal-grpc-api` is a long-running gRPC service, which uses CodeFirst to handle gRPC requests and to model the API and DTO(s)

**Service creation:**
```bash
dotnet new hive-microservice-minimal-grpc-api -pr <ProjectName> -svc <ServiceName> --solution (optional) 
```
