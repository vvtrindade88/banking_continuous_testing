# Banking Continuous Testing | RobotFramework

![Robot Framework](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXh5fs58nk232tXqRZOoByCW7Z1H6zPsHeGw&usqp=CAU)

### O que é o RobotFramework
**[RobotFramework](https://robotframework.org/)** é uma estrutura de automação genérica de código aberto. Ele pode ser usado para automação de teste e automação de processo robótico (RPA).

O **RobotFramework** tem suporte ativo, com muitas empresas líderes do setor usando-o no desenvolvimento de software.

O **RobotFramework** é aberto e extensível e pode ser integrado virtualmente a qualquer outra ferramenta para criar soluções de automação poderosas e flexíveis. Ser open source também significa que o RobotFramework é gratuito para uso, sem custos de licenciamento.

O **RobotFramework** _tem sintaxe fácil, utilizando palavras-chave legíveis por humanos_. Seus recursos podem ser estendidos por bibliotecas implementadas com Python ou Java. O framework possui um rico ecossistema ao seu redor, consistindo em bibliotecas e ferramentas que são desenvolvidas como projetos separados.

Para mais informações, acesse o site oficial do **[RobotFramework]**(https://robotframework.org/)


# Instruções para instalação do RobotFramework utilizadas no projeto

Para que o projeto **_Banking Continuous Testing_** ser executado, será necessário que o Python 3 (_ou o Python 2, porém já foi descontinuado_), o PIP (_gerenciador de pacotes do Python_) e as _Libraries_ utilizadas no projeto, além de logicamente baixar o projeto para a sua máquina :smile:


### Instalação do RobotFramework
Após a instalação do Python 3 e do PIP, o próximo passo será a instalação **RobotFramework**. Para isso, execute o seguinte comando:
> pip install robotframework

Com a instalação feita, resta instalar as libraries basicas para a criação e execução dos testes.


### **Libraries**

O **RobotFramework** já possui algumas libraries padrões, porém algumas ainda precisam ser instaladas de fora para auxilizar na agilidade da criação dos scripts.

* [Faker](https://guykisel.github.io/robotframework-faker/) :: Library geradora de dados fakes

    **Instalação**
    > pip install robotframework-faker

    **Utilização**
    > Library          FakerLibrary    locale=pt_BR


* [RequestsLibrary](https://robotframework-requests.netlify.app/doc/requestslibrary) :: Library responsáveis por gerar requisições HTTP.

    **Instalação**
    > pip install robotframework-requests

    **Utilização**
    > Library          RequestsLibrary


* [Collections](http://robotframework.org/robotframework/latest/libraries/Collections.html) :: Library que fornece palavras-chave para lidar com listas e dicionários.

    **Instalação**
    > Library Standard :: não precisa de instalação

    **Utilização**
    > Library          Collections


Para acessar outras libraries do RobotFrameworkk, [clique aqui](https://robotframework.org/#libraries)

Todas as libraries possuem uma vasta documentação, então fique tranquilo :grin::grin::grin:

# Instruções para Execução dos Scripts de Teste
