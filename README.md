# Integração DBT e Databricks
O dbt (Data Build Tool) é um framework de transformação de dados que utiliza **ANSI SQL** como linguagem principal e estende suas capacidades com recursos como **templates Jinja**, **testes de qualidade de dados em tempo de execução**, **linhagem de dados** e **documentação interativa via Web UI**.

Diferente de ferramentas como **Airflow** ou **Azure Data Factory**, o dbt **não realiza cópia nem orquestração de dados**. Ele também **não é uma engine de processamento**, mas sim uma camada de transformação que **depende de um motor de processamento** para seus modelos.

Por exemplo, ao integrar o dbt com o Databricks, é possível utilizar um SQL Warehouse como engine de processamento para as transformações definidas no projeto dbt.

Utilize uma plataforma de dados como o Databricks para federar dados diretamente das fontes ou implemente processos de ingestão e materialize os dados necessário.

<img src="https://github.com/gusantos1/dbw_dbt/blob/main/workflow-dbt.png">

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
#### 10. Dinâmica de desenvolvimento

> A partir dos dados federados ou copiados para o ambiente Databricks, você pode desenvolver localmente no VS Code usando o plugin DBT Power User. Ele permite visualizar as compilações das queries escritas com Jinja, que serão interpretadas pelo data warehouse, além de acompanhar os resultados das execuções.
Se estiver usando Poetry no ambiente de desenvolvimento, certifique-se de selecionar o interpretador correto do ambiente virtual. Caso enfrente erros — como problemas para localizar o profiles.yml — use a função de diagnóstico do plugin para ajudar na resolução.

1. Localize o interpretador do seu ambiente virtual Poetry
    \>>> poetry env info 
    ```bash
    Virtualenv
    Python:         3.13.3
    Implementation: CPython
    Path:           /home/host01/.cache/pypoetry/virtualenvs/dbt-sbnNWL-D-py3.13
    Executable:     /home/host01/.cache/pypoetry/virtualenvs/dbt-sbnNWL-D-py3.13/bin/python #Interpretador
    Valid:          True
    ```
2. No vscode use `CTRL+SHIFT+P: Python Select Interpreter` e cole o caminho em **Executable**
3. Após o interpretador ser reconhecido, espera-se que o plugin identifique automaticamente o dbt-core instalado no ambiente virtual
    <img src="https://github.com/gusantos1/dbw_dbt/blob/main/dbt-core-reconhecido.png">
4. Utilize a função `Diagnostics` do plugin para identificar erros de building do projeto
    <img src="https://github.com/gusantos1/dbw_dbt/blob/main/dbt-diagnostico.png">
5. Exemplo de diagnóstico onde o plugin não conseguiu identificr o arquivo profiles.yml
    <img src="https://github.com/gusantos1/dbw_dbt/blob/main/dbt-erro-profiles.png">
6. Exemplo de resultados com plugin Power User Dbt no vscode
    <img src="https://github.com/gusantos1/dbw_dbt/blob/main/dbt-poweruser-debug.png">
---

#### 11. Servindo a documentação com Azure Static Web Apps
> Durante a implementação o GH Actions cria um fluxo de CI/CD para atualização dos dados estáticos a cada push na branch do projeto.
<u><b>CI/CD gerado</b></u>: https://github.com/gusantos1/dbw_dbt/blob/main/.github/workflows/azure-static-web-apps-gentle-pebble-0b9f95b10.yml<br>
<u><b>Deploy da documentação</b></u>: https://gentle-pebble-0b9f95b10.6.azurestaticapps.net/#!/overview
- Predefinições de Build: `Custom (detectado)`
- Local do aplicativo(raiz do aplicativo de documentação dbt): `./main/target`
- Local da API: ` `
- Local de saída: `.`

---
#### 12. Comandos essenciais

#### Poetry

- **`poetry install`**  
  Instala todas as dependências listadas no `pyproject.toml`.

- **`poetry add <pacote>`**  
  Adiciona uma nova dependência ao projeto.

- **`poetry add --group dev <pacote>`**  
  Adiciona uma dependência ao grupo de desenvolvimento (ex: linters, dbt, etc).

- **`poetry remove <pacote>`**  
  Remove uma dependência do projeto.

- **`poetry update`**  
  Atualiza todas as dependências para a versão mais recente permitida.

- **`poetry run <comando>`**  
  Executa um comando dentro do ambiente virtual gerenciado pelo Poetry. Ex: `poetry run dbt run`

- **`poetry shell`**  
  Abre um shell com o ambiente virtual do projeto ativado.

- **`poetry env info`**  
  Exibe informações sobre o ambiente virtual atual.

- **`poetry export -f requirements.txt --without-hashes > requirements.txt`**  
  Gera um arquivo `requirements.txt` (útil para ambientes que não usam Poetry diretamente).

- **`poetry lock`**  
  Recria o arquivo `poetry.lock` com base nas versões resolvidas.

#### Tasks
- **`task deps`**  
  Instala as dependências do projeto (`packages.yml`).

- **`task clean`**  
  Limpa artefatos (`target/`, `dbt_packages/`) e compila os modelos.

- **`task build`**  
  Executa `run`, `test`, `snapshot` e `seed` — constrói e valida o pipeline completo.

- **`task run`**  
  Executa os modelos dbt (transformações SQL no warehouse).

- **`task test`**  
  Roda os testes declarativos e customizados do projeto.

- **`task seed`**  
  Carrega arquivos `.csv` da pasta `seeds/` como tabelas no banco.

- **`task snapshot`**  
  Gera snapshots (versionamento de dados ao longo do tempo).

- **`task pre_doc`**  
  Gera a documentação estática dos modelos dbt.

- **`task doc`**  
  Abre um servidor local da documentação (`http://localhost:8080`).

- **`task pre_build`**  
  Executa `pre_doc` antes do `build`, garantindo que a doc esteja atualizada.
