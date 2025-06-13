# Integração DBT e Databricks
Data Build Tool é um framework de processamento de dados baseado em ANSI SQL com funcionalidades pra superset de SQL, exemplo, Jinja template e qualidade de dados com aplicabilidade de testes em tempo de execução,linhagem de dados e documentação servida com webview.
O dbt não é ferramenta para copia ou orquestração de dados como Airflow ou Data Factory.
O dbt não é serviço de processamento, pelo contrário, o dbt se utiliza de um serviço de processamento para motor das transformações, com Databricks, o dbt pode utilizar um SQL Warehouse como poder de processamento para seus trabalhos.

![](https://github.com/gusantos1/dbw_dbt/blob/main/workflow-dbt.png?raw=true)

#### 1. Instalação do Pipx

> Instalação global de pacotes/ferramentas em ambientes isolados. Ex: Pacotes são instalados de forma global mas não fazem parte do projeto ao gerar requirements.txt.
    <u><b>Documentado</b>: https://github.com/pypa/pipx</u>


```
pip install --user pipx    # windows
python -m pipx ensurepath  # windows

sudo apt/dnf install pipx  # linux
pipx ensurepath            # linux
```
---
#### 2. Instalação do Poetry

```   
    pipx install poetry
    pipx inject poetry poetry-plugin-shell 
    #inject elimina a necessidade de chamar o comando shell aos comandos poetry
```
---
#### 3. Iniciando o ambiente virtual
    
**Terminal**:
```
    poetry new {{project_name}} --flat
    cd {{project_name}}/
    poetry python install 3.13
    poetry env use 3.13       
```

**pyproject.toml**:
```
    [project]
    #...
    requires-python = ">=3.13,<4.0"
```

**Terminal**:
```
    poetry install     
```
---
#### 4. Instalando dbt-core e taskipy

```
#Taskipy é uma ferramenta para automação na execução de linhas de código

poetry add dbt-core
poetry add dbt-databricks
poetry add --group dev taskipy
```
---
#### 5. Inicar o projeto
    
`
poetry dbt init {{PROJECT_NAME}} --flat
`

---
#### 6. Mínimo de configuração para o arquivo **pyproject.toml**

```toml
[project]
name = "{{NOME-DO-PROJETO}}"
version = "0.1.0"
description = ""
authors = [
    {name = "{{SEU_NOME}}", email = "{{SEU_EMAIL}}"}]
readme = "README.md"
requires-python = ">=3.13,<4.0"
dependencies = [
        "dbt-databricks (>=1.10.2,<2.0.0)",
        "dbt-core (>=1.9.6,<2.0.0)",]

[build-system]
requires = ["poetry-core>=2.0.0,<3.0.0"]
build-backend = "poetry.core.masonry.api"

[tool.poetry.group.dev.dependencies]
taskipy = "^1.14.1"

[tool.taskipy.tasks]
pre_doc = "dbt docs generate"
pre_build = "dbt clean && dbt compile && task pre_doc"
build = "dbt build --profiles-dir"
deps = "dbt deps"
doc = "dbt docs serve --port 8080"
run = "dbt run"
snapshot = "dbt snapshot"
seed = "dbt seed"
test = "dbt test"
```

---
#### 7. Mínimo de configuração para o arquivo **profiles.yml**
> Por padrão o arquivo **profiles.yml** está localizado em **/~/.dbt/profiles.yml**, mas você pode alterar para que o arquivo faça parte da raiz do projeto.
<u><b>Documentado</b>: https://docs.getdbt.com/docs/core/connect-data-platform/connection-profiles</u>
<u><b>Exemplo</b>: https://github.com/gusantos1/dbw_dbt/blob/main/profiles.yml</u>

Em **profiles.yml**:
```yml
{{profile-name}}: #Por padrão, mesmo nome do projeto
target: dbw_dev #Workspace de desenvolvimento
outputs:
    dbw_dev:
    catalog: ... #Nome do catálogo no unity catalog
    schema: ... #Nome do schema
    host: "{{ env_var('DATABRICKS_HOST') }}" #definido na env local do ambiente
    http_path: "{{ env_var('DATABRICKS_HTTP_PATH') }}" #definido na env local do ambiente
    token: "{{ env_var('DATABRICKS_TOKEN') }}" #definido na env local do ambiente
    type: databricks
    threads: 1 #altere conforme as tasks e config do cluster
    
```
- **Opções**:
    **1ª Pelo terminal**: `dbt run --profiles-dir .`
    **2ª Por variável de ambiente**: `export DBT_PROFILES_DIR=$(pwd)`

---
#### 8. Arquivo para não concatenar o nome dos schemas
> Por padrão o dbt reconhece o nome dos schemas através dos arquivos .sql da pasta **models** (rdefinir aqui reescreve os demais), em **db_project.yml** e **profiles.yml** (sendo esse, **obrigatório** para conexão com job cluster/DW).
<u><b>Exemplo</b>: https://github.com/gusantos1/dbw_dbt/blob/main/main/dbt_project.yml</u>

1- Em models através do placeholder `{{config (schema='nome_do_schema')}}`
2- Em **db_project.yml**  
```
    models:
    myproject:
        refined:
        +materialized: view
        +schema: gold #schema no databricks {catalog}.{schema}.{table}
```

3- Criando o arquivo **generate_schema_name.sql**
> Por padrão o dbt concatena os nomes dos schemas com o que foi definido inicialmente no arquivo **profiles.yml**, é necessário reescrever a função para alterar esse comportamento. 
<u><b>Documentado</b>: https://docs.getdbt.com/docs/build/custom-schemas</u>
<u><b>Exemplo</b>: https://github.com/gusantos1/dbw_dbt/blob/main/main/macros/generate_schema_name.sql</u>

**/macros/generate_schema_name.sql**:
```sql
{% macro generate_schema_name(custom_schema_name, node) %}
    {{ custom_schema_name }} #Usará apenas o nome que foi passado.
{% endmacro %}
```

---
#### 9. Entendimento da estrutura do projeto

```
>>> tree -a -L 2

├── dbt
├── .git
├── .github
│   └── workflows           #Arquivo de CI/CD gerado pelo Azure Static Web Apps para servir a documentação em /target
├── .gitignore
├── logs
├── main                    
│   ├── analyses            #Arquivos .sql para consultas ad-hoc 
│   ├── dbt_packages        #Gerado ao executar o arquivo `dbt deps`
│   ├── dbt_project.yml     #Arquivo mais importante do projeto
│   ├── logs                #Append de execuções (infos, warnings e erros)
│   ├── macros              #Funções e testes em .sql 
│   ├── models              #Arquivos .sql(transformações) e schemas.yml usados para documentação e testes (data quality)
│   ├── package-lock.yml
│   ├── packages.yml        #Arquivo para instalação de pacotes e extensão de funções (ex:dbt_utils)
│   ├── seeds               #Arquivos .csv no projeto, normalmente para de-para
│   ├── snapshots           #Versões historificadas dos dados, utilizadas para detectar mudanças (ex: SCD2)
│   ├── target              #Documentação e linhagem gerado por `dbt docs generate`
│   ├── tests               #Testes genéricos em SQL (https://docs.getdbt.com/best-practices/writing-custom-generic-tests)
├── poetry.lock
├── profiles.yml            #Arquivo de configuração pra conexão com a engine de processamento
├── pyproject.toml          #Arquivo de configuração do Poetry pro projeto
├── README.md
├── tests
```
---
#### 12. Servindo a documentação com Azure Static Web Apps
> Durante a implementação o GH Actions cria um fluxo de CI/CD para atualização dos dados estáticos a cada push na branch do projeto.
<u><b>CI/CD gerado</b></u>: https://github.com/gusantos1/dbw_dbt/blob/main/.github/workflows/azure-static-web-apps-gentle-pebble-0b9f95b10.yml
<u><b>Deploy da documentação</b></u>: https://gentle-pebble-0b9f95b10.6.azurestaticapps.net/#!/overview
- Predefinições de Build: `Custom (detectado)`
- Local do aplicativo(raiz do aplicativo de documentação dbt): `./main/target`
- Local da API: ` `
- Local de saída: `.`

---
#### Comandos essenciais
#### 10. Dinâmica de desenvolvimento
A partir dos dados federados ou copiados para ambiente Databricks, você irá desenvolver as consultas direto pelo DW para melhorar visualização e saídas, plugin vscode
dbt docs generate para enxergar a compilação da sintaxe