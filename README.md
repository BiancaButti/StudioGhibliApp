# 🎬 StudioGhibliApp

Aplicativo que faz a exibição de uma lista de filmes do Studio Ghibli e tela de detalhes de cada um dos filmes. 

![Badge Finalizado](https://img.shields.io/static/v1?label=STATUS&message=FINALIZADO&color=green&style=for-the-badge)




## 📱 Tecnologia

![xcode](https://img.shields.io/badge/Xcode-14.2-blue?style=for-the-badge&logo=xcode&logoColor=white)

![Simulador](https://img.shields.io/badge/Simulator-iPhone%2014%20%7C%20iOS%2016.2-lightgrey?style=for-the-badge&logo=apple&logoColor=black)
  
![swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)

![github](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)



## 🧩 Estrutura e Funcionamento

O projeto segue a arquitetura MVVM, com separação de responsabilidades entre view e controllers, serviço da api e exibição dos dados. 

A tela de listagem de filmes (ou a home do app) exibe informações como imagem, título e ano de lançamento, e uma search bar. 
- **Carregamento dos dados:** ao abrir a tela, os dados são carregados de forma assíncrona.
- **Tratamento de estados:** a tela trata três estados principais:
    - **Loading (carregamento):** enquanto os dados são buscados.
    - **Content (conteúdo):** exibe os dados carregados corretamente.
    - **Error (erro):** exibe uma mensagem de erro em caso de falha.

Para isso, foi utilizado os componentes: 
- `StateViewManager`: gerencia qual visual deve ser exibido com base no estado atual.
- `ÈmptyStateView`: exibe mensagens para estados vazios ou de erro.
- `MovieDetailContentView`: exibe o conteúdo quando os dados são carregados com sucesso.
- `AppCoordinator`/`Coordinator`: responsável pela navegação entre telas

Além disso, foi implementado um **cache local** para evitar chamadas desnecessárias e melhorar performance da aplicação.



## 🧪 Testes

Foi incluído testes unitários para garantir o funcionamento correto da lógica de negócios e exibição de estados, respeitando a taxa de cobertura de 80%.


## 📌 Organização e Issues

Mesmo com o projeto concluído, todas as tarefas e melhorias foram documentadas via [Issues do GitHub](https://github.com/BiancaButti/StudioGhibliApp/issues?q=is%3Aissue+state%3Aclosed) e [Pull Requests](https://github.com/BiancaButti/StudioGhibliApp/pulls?q=is%3Apr+is%3Aclosed), que já estão todas fechadas.

Essa prática foi adotada para manter o controle do progresso e registrar etapas do desenvolvimento de forma clara e organizada.


## Demonstração 

![StudioGhibliApp](https://github.com/user-attachments/assets/937a6771-9325-4bf5-8e94-ff36f419a502)


## 🚀 Como rodar o projeto
1. Clone este [repositório](https://github.com/BiancaButti/StudioGhibliApp.git).
2. Verificar se possui o Xcode e buildar o projeto

Obs.: Não foram inseridos libs externas. 

