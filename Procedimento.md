# Trabalho de AeD 3: RSA e AES

Aluno: Jonathas Augusto de Oliveira Conceição.

Como criptoanalista no Biuro Szyfrów, você interceptou uma mensagem cifrada, criptografada com AES 256 bits, cuja chave foi criptografada utilizando uma chave pública RSA. Você tem acesso tanto a mensagem cifrada como a chave cifrada. Sabe ainda que provavelmente foi utilizado o programa openssl para realizar ambas encriptações.

Sua tarefa é obter a mensagem cifrada.

Ao concluir a tarefa, submeta os procedimentos adotados que permitam replicar o processo, bem como a senha e a mensagem originais, em um único arquivo PDF.

A nota deste trabalho comporá 20% da nota final da disciplina. Será avaliado da seguinte forma:

- Nota máxima para os trabalhos corretos entregues até o dia 10/08;
- 75% da nota máxima para trabalhos corretos entregues até a data da segunda prova;
- Cada trabalho correto entregue até a data da segunda prova receberá até 2,0 pontos adicionais. O bônus de 2 pontos será dividido pelo número de trabalhos corretos entregues pela turma.

## Porcedimento utilizado
Primeiramente foi utilizado o openssl para extrair o **modulus** e **expoente público** da chave RSA pública:  
**openssl rsa -pubin -inform PEM -text**

N = 4429974973391516600116543573718405546879849243793857316751
E = 65537

O site http://www.numberempire.com/numberfactorizer.php foi então utilizado para fatorar o **modulus** e encontrar os fatores prímos, **P** e **Q**:  
P = 64624507535936447523680179787  
Q = 68549458128220050192491632973  

Um simples código Haskell retirado do wikibooks.org foi utilizado para calcular o Algorítimo Euclidiano Extendido e encontrar o modular multiplicativo inverso do expoente público:  
D = 1508585706641315096531745723412350251454473514304313366161  
