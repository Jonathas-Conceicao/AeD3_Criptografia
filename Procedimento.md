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

Um simples código Haskell retirado do wikibooks.org foi utilizado para calcular o Algorítimo Euclidiano Extendido e encontrar o modular multiplicativo inverso do expoente público e outros valores necessários:  
D = 1508585706641315096531745723412350251454473514304313366161  
E1= 30837576089405076878832571867  
E2= 35951935163086188950002630705  
Coeff= 62783713230537502537669730250  

Essas informações foram postas num arquivo de configuração asn1 para gerar o certificado da chave privada utilizando:  
```
openssl asn1parse -genconf config.cnf -out newKeyPair.der  
```

Com isso pode-se gerar a chave privada com:  
```
openssl rsa -inform der -in newKeyPair.der -out private.pem    
```

Agora para descriptografar a chave da mensagem:  
```
openssl rsautl -decrypt -in cipher_key -out cipher_key_dec -inkey private.key   
```
Eis a chave descriptografada:  
**Zimmermann**  

Apesar de tudo quando eu tento descriptografar o texto original com a chave encontrada apenas caracteres especiais e uma mensagem de erro são dados como resposta.
A chave RSA privada parece certa, pois o *-check* dela retorna *"RSA key ok"*, os valores lidos dela batem com os cálculos e a chave pública extraída dela é exatamente a mesma fornecida pelo professor para o trabalho.

Eu não sei bem o que eu fiz errado durante o processo para que eu não conseguisse chegar ao resultado final.
Mas os passos apresentados aqui foi o mais longe que eu consegui chegar no que eu acredito ser o caminho certo.
Comando utilizado para descriptografar o texto original:  
```
openssl aes-256-cbc -d -a -in cipher_text -pass file:./cipher_key_dec -out cipher_text_dec
```
Erro recebido:
```
bad decrypt  
139669847017216:error:06065064:digital envelope routines:EVP_DecryptFinal_ex:bad decrypt:crypto/evp/evp_enc.c:568:
```
