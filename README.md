# ionized microservice templates

TBA

## template installation

At the moment the simplest method of installing the templates is checking out this repository and manually installing the templates within

```bash
git clone https://github.com/ionizd/templates.git
cd microservice
dotnet new -i ./
```

## supported parameters check

In order to check the list of supported template parameters, you can use:

```bash
dotnet new ion-microservice --help
```

## template usage

In order to use a template while setting up a new project, you can use the following commandline as reference.

```bash
mkdir <Project>
cd <Project>
git init .
dotnet new ion-microservice
```

## templating reference

- [Custom templates for dotnet](https://docs.microsoft.com/en-us/dotnet/core/tools/custom-templates)
- [Markdown syntax for templating](https://stackoverflow.com/questions/53422381/what-is-the-markdown-syntax-for-net-core-templating)
- [Optional files](https://dotnetninja.net/2021/03/creating-project-templates-for-dotnet-part-2-optional-files/)
- [File rename for generated symbols](https://github.com/dotnet/templating/issues/2507)