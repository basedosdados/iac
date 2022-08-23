# ☁️ iac

<a name="readme-top"></a>

[![Contributors][Contributors-shield]][Contributors-url]
[![Forks][Forks-shield]][Forks-url]
[![Stargazers][Stars-shield]][Stars-url]
[![Issues][Issues-shield]][Issues-url]
[![MIT License][License-shield]][License-url]

<!-- TABLE OF CONTENTS -->
<details>
    <summary>Sumário</summary>
    <ol>
        <li>
            <a href="#sobre-o-projeto">Sobre o projeto</a>
            <ul>
                <li>
                    <a href="#construído-com">Construído com</a>
                </li>
            </ul>
        </li>
        <li>
            <a href="#desenvolvimento-local">Desenvolvimento local</a>
            <ul>
                <li>
                    <a href="#requisitos">Requisitos</a>
                </li>
                <li>
                    <a href="#procedimentos">Procedimentos</a>
                </li>
            </ul>
        </li>
        <li>
            <a href="#uso">Uso</a>
        </li>
        <li>
            <a href="#roadmap">Roadmap</a>
        </li>
        <li>
            <a href="#contribuição">Contribuição</a>
        </li>
        <li>
            <a href="#licença">Licença</a>
        </li>
        <li>
            <a href="#contato">Contato</a>
        </li>
    </ol>
</details>
</br>

<!-- Sobre o projeto -->
## Sobre o projeto

Gerenciamento da infraestrutura dos serviços utilizados do Google Cloud Platform e das aplicações desenvolvidas/implantadas em nosso cluster Kubernetes, bem como as suas respectivas configurações.

<p align="right">(<a href="#readme-top">voltar ao início</a>)</p>

### Construído com

[![GCP][GCP-shield]][GCP-url]
[![GitHub Actions][Github-Actions-shield]][GitHub-Actions-url]
[![Kubernetes][Kubernetes-shield]][Kubernetes-url]
[![Terraform][Terraform-shield]][Terraform-url]

<p align="right">(<a href="#readme-top">voltar ao início</a>)</p>

<!-- Desenvolvimento local -->
## Desenvolvimento local

### Requisitos

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Credenciais:
  - Terraform: Uma conta de serviço do ambiente GCP com o papel de "Editor"
  - Kubernetes: Uma conta de serviço do ambiente GCP com o papel de "Kubernetes Engine Admin"


### Procedimentos

1. Clone o repositório e acesse a pasta do projeto

   ```sh
    git clone https://github.com/basedosdados/iac.git && cd iac
   ```

2. Execute o comando abaixo para iniciar o ambiente de desenvolvime
   ```sh
    make create-dev
   ```

    Útil: Consulte o arquivo `Makefile` para mais comandos.

#### **Terraform**

1. Adicione o arquivo de credencial (`credencial.json`) no diretório `terraform/`.
2. Note a existência do arquivo `.env.example` dentro do diretório `terraform`. Faça uma cópia do mesmo para um novo arquivo, nomeado `.env`, e preencha as variáveis de ambiente com os valores correspondentes.

    ```sh
    cp terraform/.env.example terraform/.env
    ```

    Obs.: No caso do desenvolvimento local é criado um container docker, baseado na imagem do Terraform que faz uso do arquivo `.env` para definir as variáveis de ambiente necessárias para a execução do Terraform. Extinguindo a necessidade de instalar o Terraform localmente.
3. Carregue as variáveis de ambiente do arquivo `.env` no terminal atual.

    ```sh
    source terraform/.env
    ```
4. Execute o comando abaixo para criar o container docker e validar as configurações do Terraform.

    ```sh
    make docker-up
    ```

Caso a saída seja semelhante ao exemplo abaixo, a configuração foi realizada com sucesso.

    ```sh
    bdd_terraform    | Initializing modules...
    bdd_terraform    |
    bdd_terraform    | Initializing the backend...
    bdd_terraform    |
    bdd_terraform    | Initializing provider plugins...
    bdd_terraform    | - terraform.io/builtin/terraform is built in to Terraform
    bdd_terraform    | - Reusing previous version of hashicorp/google from the dependency lock file
    bdd_terraform    | - Using previously-installed hashicorp/google v3.89.0
    bdd_terraform    |
    bdd_terraform    | Terraform has been successfully initialized!
    bdd_terraform    |
    bdd_terraform    | You may now begin working with Terraform. Try running "terraform plan" to see
    bdd_terraform    | any changes that are required for your infrastructure. All Terraform commands
    bdd_terraform    | should now work.
    bdd_terraform    |
    bdd_terraform    | If you ever set or change modules or backend configuration for Terraform,
    bdd_terraform    | rerun this command to reinitialize your working directory. If you forget, other
    bdd_terraform    | commands will detect it and remind you to do so if necessary.
    ```

#### **Kubernetes**

Para interagir com o cluster k8s em questão, além das permissões necessárias, é necessário ter o kubectl instalado. Siga os passos conforme a [documentação oficial do Google](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#gcloud).


## Uso

Para exemplos de utilização das ferramentas deste projeto, favor consultar a documentação <!-- TODO: Adicionar referência da documentação global sobre `iac` -->

## Roadmap

Além das tarefas em aberto que pode ser consultadas em [issues][Issues-url], o projeto é baseado no planejamento de milestones que podem ser consultados em [milestones][Milestones-url].

## Contribuição

As contribuições são o que tornam a comunidade de código aberto um lugar incrível para aprender, inspirar e criar. Quaisquer contribuições que você fizer são **muito apreciadas**.

Se você tiver uma sugestão de melhoria, faça um fork do repositório e crie um pull request. Você também pode simplesmente abrir uma tarefa.

Não se esqueça de dar uma estrela ao projeto! Agraddecemos o apoio 💚!

## Licença

<!-- TODO: Adicionar licença -->
<!-- Distribuído sob a licença GPL-3.0. Consulte `LICENSE` para obter mais informações. -->

## Contato

Você pode entrar em contato com a equipe da Base dos Dados via diversos canais:

[![Discord][Discord-shield]][Discord-url]
[![LinkedIn][LinkedIn-shield]][LinkedIn-url]
[![Telegram][Telegram-shield]][Telegram-url]
[![Twitter][Twitter-shield]][Twitter-url]
[![WhatsApp][WhatsApp-shield]][WhatsApp-url]

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[Contributors-shield]: https://img.shields.io/github/contributors/basedosdados/iac?style=for-the-badge
[Contributors-url]: https://github.com/basedosdados/iac/graphs/contributors
[Discord-shield]: https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white
[Discord-url]: https://discord.com/invite/huKWpsVYx4
[Forks-shield]: https://img.shields.io/github/forks/basedosdados/iac?style=for-the-badge
[Forks-url]: https://github.com/baseosdados/iac/network/members
[GCP-shield]: https://img.shields.io/badge/GCP-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white
[GCP-url]: https://cloud.google.com/
[GitHub-Actions-shield]: https://img.shields.io/badge/GitHub%20Actions-000000?style=for-the-badge&logo=github-actions&logoColor=white
[GitHub-Actions-url]: https://github.com/features/actions
[Issues-shield]: https://img.shields.io/github/issues/basedosdados/iac?style=for-the-badge
[Issues-url]: https://github.com/basedosdados/iac/issues
[Kubernetes-shield]: https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white
[Kubernetes-url]: https://kubernetes.io/
[License-shield]: https://img.shields.io/github/license/basedosdados/iac?style=for-the-badge
[License-url]: https://github.com/basedosdados/iac/blob/master/LICENSE
[LinkedIn-shield]: https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white
[LinkedIn-url]: https://www.linkedin.com/company/base-dos-dados/
[Milestones-shield]: https://img.shields.io/github/milestones/all/basedosdados/iac?style=for-the-badge
[Milestones-url]: https://github.com/basedosdados/iac/milestones
[Stars-shield]: https://img.shields.io/github/stars/basedosdados/iac?style=for-the-badge
[Stars-url]: https://github.com/basedosdados/iac/stargazers
[Telegram-shield]: https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white
[Telegram-url]: https://t.me/joinchat/OKWc3RnClXnq2hq-8o0h_w
[Terraform-shield]: https://img.shields.io/badge/Terraform-623CE4?style=for-the-badge&logo=terraform&logoColor=white
[Terraform-url]: https://www.terraform.io/
[Twitter-shield]: https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white
[Twitter-url]: https://twitter.com/basedosdados
[Whatsapp-shield]: https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white
[Whatsapp-url]: https://chat.whatsapp.com/CLLFXb1ogPPDomCM6tQT22
