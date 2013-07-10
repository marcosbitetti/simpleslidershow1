#Simple Slider Show

## Sobre
Um simples mecanismo de slide, adaptável. Feito em Coffee Script.
Capaz de ser integrado a qualquer elemento da página.

## Live demo
1. [Exemplo on-line][1]


## Como usar
1. Tenha o arquivo executável wslider.js em algum lugar. (No DropBox por exemplo).
1. Para inserir na página/blog crie uma DIV ou qualquer elemento para conter o slider.
1. Insira primeiro os parâmetros de configuração (se estes parâmetros não forem inseridos primeiro o slider não funciona)
1. Por último o link para wslider.js.

#### exemplo simples

    <script type="text/javascript">
    var slides=["image_n0.jpg","image_n1.jpg","image_n2.jpg"];
    var slides_path = "https://dl.dropboxusercontent.com/u/{suaID}/";
    var slides_trans = "alternate";
    </script>

#### exemplo com links para as imagens
A diferença é que usamos uma informação a mais e passamos por colchetes ( [ e ] ):

    <script type="text/javascript">
    var slides=[
        ["image_n0.jpg","http://endereço1.html"],
        ["image_n1.jpg","http://endereço2.html"],
        ["image_n2.jpg","http://endereço3.html"]
    ];
    var slides_path = "https://dl.dropboxusercontent.com/u/{suaID}/";
    var slides_trans = "alternate";
    </script>

### Outras configurações
Para selecionar uma seta diferente acrescente a linha:

    var slides_seta = "http://URLDaImagemDaSeta.png";

### Reusar o slider?
Para usar o slider basta repetir o mesmo código em qualquer outro lugar da página.
Não se esqueça que no final da configuração precisa inserir a chamada ao wslider.js para que ele execute novamente com os valores novos.


## Desenvolvimento
### Como compilar?
O Slider foi desenvolvido em Coffee Script.
Instale o compilador com este [tutorial][2].
Use este comando para compilar uma única vez:

    coffee --output js/ --compile wslider.coffee

Ou use este comando para compilar toda vez que salvar o código fonte:

    coffee --watch --output js/ --compile wslider.coffee

###Crédito
<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/deed.pt"><img alt="Licença Creative Commons" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" /></a><br />O trabalho <span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/InteractiveResource" property="dct:title" rel="dct:type">Simple Slider Show</span> de <a xmlns:cc="http://creativecommons.org/ns#" href="http://lab-nerdofthemontain.rhcloud.com/" property="cc:attributionName" rel="cc:attributionURL">Marcos Augusto Bitetti</a> foi licenciado com uma Licença <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/deed.pt">Creative Commons - Atribuição-CompartilhaIgual 3.0 Não Adaptada</a>.


  [1]: https://googledrive.com/host/0B6cWl9Nlsty3U1lHVjVvVlNMTnM/index.html
  [2]: http://labs-nerdofthemontain.openshift.com