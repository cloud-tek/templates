# ionizd/templates

## Gettings started

```bash
# Install the 'dotnet new' templates
./Install-Templates.ps1
```
## Templates

This repository contains a selection of Ion service templates

### ion-job

> **Description**
>
> The `ion-job` is a one-time fire & forget service which is intended to start, do it's work and shut down. Ideal for k8s cronjobs scenario(s).

**Service creation:**
```bash
dotnet new ion-job --project <ProjectName> --service <ServiceName> --solution (optional) 
```

### ion-microservice

> **Description**
>
> The `ion-microservice` is a long-running background processor which is not exposing any API endpoints apart from standard `/status` endpoints. It's primary uses are:
> - Task scheduling
> - Async message processing

**Service creation:**
```bash
dotnet new ion-microservice --project <ProjectName> --service <ServiceName> --solution (optional) 
```

### ion-microservice-api

> **Description**
>
> The `ion-microservice-api` is a long-running REST-ful service, which uses Controllers to handle incoming HTTP requests

**Service creation:**
```bash
dotnet new ion-microservice-api --project <ProjectName> --service <ServiceName> --solution (optional) 
```

### ion-microservice-minimal-api

> **Description**
>
> The `ion-microservice-minimal-api` is a long-running REST-ful service, which uses minimal APIs to handle incoming HTTP requests

**Service creation:**
```bash
dotnet new ion-microservice-minimal-api --project <ProjectName> --service <ServiceName> --solution (optional) 
```

### ion-microservice-graphql-api

> **Description**
>
> The `ion-microservice-graphql-api` is a long-running GraphQL service, which uses [HotChocolate](https://chillicream.com/docs/hotchocolate) to handle GraphQL requests. 
>
> Primary uses:
> - API gateway
> - BFF (backend for frontend)

**Service creation:**
```bash
dotnet new ion-microservice-graphql-api --project <ProjectName> --service <ServiceName> --solution (optional) 
```

### ion-microservice-grpc-api

> **Description**
>
> The `ion-microservice-grpc-api` is a long-running gRPC service, which uses ProtoBuf to handle gRPC requests and `.proto` files to model the API and DTO(s)

**Service creation:**
```bash
dotnet new ion-microservice-grpc-api --project <ProjectName> --service <ServiceName> --solution (optional) 
```

### ion-microservice-minimal-grpc-api

> **Description**
>
> The `ion-microservice-minimal-grpc-api` is a long-running gRPC service, which uses CodeFirst to handle gRPC requests and to model the API and DTO(s)

**Service creation:**
```bash
dotnet new ion-microservice-minimal-grpc-api --project <ProjectName> --service <ServiceName> --solution (optional) 
```
