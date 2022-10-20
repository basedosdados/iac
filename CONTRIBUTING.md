# CONTRIBUTING

Antes de iniciar, deixamos o nosso agradecimento por sua intenção e futura contribuição! 💚

## Código de Conduta

⚠️ **Não toleramos** qualquer tipo de discussão que possa, a qualquer instante, ofender ao invés de agregar; Propagandas de produtos/serviços não educativos; Conteúdo pornográfico ou ofensivo a qualquer tipo de comunidade; Discurso de ódio.

## Como contribuir

Os passos abaixo descrevem os passos necessários para que a sua contribuição seja incorporada a nossa base de código. O tutorial é dedicado a não-membros da **Base dos Dados** e, assim, cobre apenas o caso de desenvolvimento local. Futuramente, o desenvolvimento em cloud estará disponível também para não-membros.

### Configuração de ambiente para desenvolvimento

#### Requisitos

* Um editor de texto (recomendado VSCode);
* (Opcional, mas recomendado) Um ambiente virtual para desenvolvimento (`miniconda`, `virtualenv` ou similares)

#### Estrutura do Projeto

Logo abaixo está a estrutura do projeto em seu primeiro level, estão organizados por ferramentas utilizadas.

```
.
├── docker-compose.yaml         # Arquivo de configuração do Docker Compose para apoiar as tarefas no ambiente de desenvolvimento
├── .github/                    # Diretório com automações do ambiente via GitHub Actions
├── .gitignore                  # Arquivo de configuração do git (Arquivos/Diretórios não versionados)
├── k8s/                        # Diretório por namespace (aplicação) disponível no k8s e seus manifestos
├── Makefile                    # Arquivo de alias de comandos úteis para o projeto
├── .mergify.yaml               # Arquivo de configuração do mergify
├── .pre-commit-config.yaml     # Arquivo de configuração do pre-commit
├── README.md                   # Descrição inicial do projeto
├── terraform/                  # Diretório por módulos utilizados do projeto via Terraform
└── utils                       # Diretório com scripts úteis para o projeto
```

#### Procedimentos

- Clonar esse repositório em sua máquina local

  ```sh
  git clone https://github.com/basedosdados/iac.git
  ```

- Criar e ativar um ambiente virtual

  ```sh
  python3 -m venv .venv
  source .venv/bin/activate
  ```

- Instalar o poetry

  ```sh
  pip install poetry
  ```

- Instalar os hooks do pre-commit

  ```sh
  pre-commit install
  ```

- Pronto! Seu ambiente está configurado para desenvolvimento.

Em caso de desenvolvimento de módulos Terraform, ao submeter um PR, as modificações em seus códigos serão consideradas no teste de CI. Onde é realizado a validação dos manifestos terraform; E caso passe nesta validação, será executado o planejamento do Terraform e as modificações a serem aplicadas no ambiente serão exibidas em seu PR no formato do planejamento do Terraform. Fazendo com que o review do seu código tenha uma maior facilidade de interpretação.

Já as contribuições dos manifestos do _k8s_ serão analisadas manualmente pela equipe de _infra_ da **Base dos Dados**.
