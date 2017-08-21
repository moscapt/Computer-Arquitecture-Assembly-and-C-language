;Projeto 2 AC 2014/2015

;André Braga 	 EQU 2077508
;Ricardo Pereira EQU 2034008

;!!!!!!!!!!!!!!!!!!!!!!!!
;!! Máquina de Bebidas !!
;!!		 PEPE's		   !!
;!!!!!!!!!!!!!!!!!!!!!!!!

;RESUMO DO USO DOS REGISTOS:
;R0 - Guarda Opçao de seleçao / Guarda menus e taloes a escrever
;R1 - Endereço do stock da bebida escolhida
;R2 - Quantidade de stock da bebida
;R3 - Preço da bebida escolhida
;R4 - Soma total do input do user / troco a receber pelo user
;R7 - Guarda qual o erro a escrever
;R8 - Var de controlo que detecta escolha errada no menu
;R9 - Var de controlo que diz se tem stock da bebida em questao ou nao
;R10 - Var de controlo que diz se o input do utilizador foi menor ou igual ao preço E se a maquina deu troco ou nao

;----------------------------;
;  DEFENIÇAO DAS CONSTANTES  ;
;----------------------------;

;----------------;
; Valor em ascii ;
;----------------;

Ascii EQU 30H
ENDdaBebida1ValorDecimal EQU 0300H
ENDdaBebida2ValorDecimal EQU 0310H
ENDdaBebida3ValorDecimal EQU 0320H
;-----------------;
;Display principal;
;-----------------;

Display       EQU 0010H 	;endereço da primeira linha do display
FimDisplay    EQU 0070H		;endereço da ultima linha de display (possivelmente 13 ao todo, devido a janela stock)
NumCaracteres EQU 16		;Cada string possui 16 caracteres;
CaracterVazio EQU 0020H   	;Caracter para limpar ecra

;----------------------------;
;Botoes de Selecao de maquina;
;----------------------------;

Selecao       EQU 0091H		;Endereco de botao de selecao da opcao pretendida;

;------------;
;stackPointer;
;------------;

StackPointer EQU 5000H		;Endereço da primeira linha do stack pointer;

;--------------;
;Menu Principal;
;--------------;

BebidasSemGas  EQU 1 		;opcao bebidas sem gas(usado para comparar e saber proximo menu para display);
BebidasComGas  EQU 2 		;opcao bebidas com gas

;--------------------;
;Menu bebidas sem Gas;   
;--------------------;

Compal    EQU 1			;opcao compal
Agua      EQU 2			;opcao agua
Redbull   EQU 3			;opcao redbull
Voltar    EQU 4			;Opçao para voltar atras

;--------------------;
;Menu bebidas com gas;
;--------------------;

Cola     EQU 1			; opcao cola
Fanta    EQU 2			; opcao fanta
Sprite   EQU 3			; opcao sprite

;------------------------------------;
; Stocks e quantidade de cada moeda  ;
;------------------------------------;

StockCompal  EQU 00B1H	; endereco do stock de compal
StockAgua    EQU 00C1H 	; endereco do stock de agua
StockRedbull EQU 00D1H	; endereco do stock de redbull
StockCola    EQU 00E1H	; endereco do stock da coca-cola
StockFanta   EQU 00F1H	; endereco do stock da fanta
StockSprite	 EQU 0101H	; endereco do stock da sprite

Stock500	 EQU 00E3H	; endereco do stock de notas de 5 euro
Stock200	 EQU 00E4H	; endereco do stock de moedas de 2 euro
Stock100	 EQU 00E5H	; endereco do stock de moedas de 1 euro
Stock050	 EQU 00E6H	; endereco do stock de moedas de 50 centimos
Stock020	 EQU 00E7H	; endereco do stock de moedas de 20 centimos
Stock010	 EQU 00E8H	; endereco do stock de moedas de 10 centimos

AuxStock500	 EQU 0103H	; endereco da copia do stock de notas de 5 euro
AuxStock200	 EQU 0104H	; endereco do copia do stock de moedas de 2 euro
AuxStock100	 EQU 0105H	; endereco do copia do stock de moedas de 1 euro
AuxStock050	 EQU 0106H	; endereco do copia do stock de moedas de 50 centimos
AuxStock020	 EQU 0107H	; endereco do copia do stock de moedas de 20 centimos
AuxStock010	 EQU 0108H	; endereco do copia do stock de moedas de 10 centimos

;---------------------;
; Precos das bebidas  ;
;---------------------;

PrecoCompal	 EQU 100	;Preco da bebida Compal
PrecoAgua	 EQU 50		;Preco da bebida Agua
PrecoRedbull EQU 170	;Preco da bebida Redbull

PrecoCola	 EQU 100	;Preco da bebida Cola
PrecoFanta	 EQU 100	;Preco da bebida Fanta
PrecoSprite	 EQU 100	;Preco da bebida Sprite

;------------------------------------;
;  Perifericos de inputs das moedas  ;
;------------------------------------;

Input500  EQU 00A3H		; endereco do periferico para input de 5 euros
Input200  EQU 00A4H		; endereco do periferico para input de 2 euro
Input100  EQU 00A5H		; endereco do periferico para input de 1 euro
Input050  EQU 00A6H		; endereco do periferico para input de 50 centimos
Input020  EQU 00A7H		; endereco do periferico para input de 20 centimos
Input010  EQU 00A8H		; endereco do periferico para input de 10 centimos

;-------------------------;
;  Perifericos de output  ;
;-------------------------;

Output500  EQU 00C3H	; endereco do periferico para output de 5 euros
Output200  EQU 00C4H	; endereco do periferico para output de 2 euro
Output100  EQU 00C5H	; endereco do periferico para output de 1 euro
Output050  EQU 00C6H	; endereco do periferico para output de 50 centimos
Output020  EQU 00C7H	; endereco do periferico para output de 20 centimos
Output010  EQU 00C8H	; endereco do periferico para output de 10 centimos

;--------------------;
; Valores das moedas ; 
;--------------------;

Valor500  EQU 500	;Valor da Nota de 5 euros
Valor200  EQU 200	;Valor da Moeda de 2 euros
Valor100  EQU 100	;Valor da Moeda de 1 euros
Valor050  EQU 50	;Valor da Moeda de 50 centimos
Valor020  EQU 20	;Valor da Moeda de 20 centimos
Valor010  EQU 10	;Valor da Moeda de 10 centimos

;------------;
;  Programa  ;  
;------------;

PLACE 0000H							; Primeira instrução do programa principal
Inicio:
	MOV R0,  InicializacaoStocks	; Salta para a inicializaçao de stocks
	JMP R0

;---------------------------;
;  Inicialização de Stocks  ;
;---------------------------;
PLACE 1000H
InicializacaoStocks:

;INICIALIZAÇAO DO STOCK DE COMPAL
	MOV R1, 100
	MOV R2, StockCompal
	MOVB [R2], R1
;INICIALIZAÇAO DO STOCK DE AGUA
	MOV R1, 100
	MOV R2, StockAgua
	MOVB [R2], R1
;INICIALIZAÇAO DO STOCK DE REDBULL	
	MOV R1, 100
	MOV R2, StockRedbull
	MOVB [R2], R1
;INICIALIZAÇAO DO STOCK DE COLA
	MOV R1, 100
	MOV R2, StockCola
	MOVB [R2], R1
;INICIALIZAÇAO DO STOCK DE FANTA	
	MOV R1, 100
	MOV R2, StockFanta
	MOVB [R2], R1
;INICIALIZAÇAO DO STOCK DE SPRITE	
	MOV R1, 100
	MOV R2, StockSprite
	MOVB [R2], R1
	
;INICIALIZAÇAO DO STOCK DE NOTAS DE 5 EUROS
	MOV R1, 200
	MOV R2, Stock500
	MOVB [R2], R1
;INICIALIZAÇAO DO STOCK DE MOEDAS DE 2 EUROS
	MOV R1, 200
	MOV R2, Stock200
	MOVB [R2], R1
;INICIALIZAÇAO DO STOCK DE NOTAS DE 1 EURO
	MOV R1, 200
	MOV R2, Stock100
	MOVB [R2], R1
;INICIALIZAÇAO DO STOCK DE MOEDAS DE 50 CENTS
	MOV R1, 200
	MOV R2, Stock050
	MOVB [R2], R1
;INICIALIZAÇAO DO STOCK DE MOEDAS DE 20 CENTS
	MOV R1, 200
	MOV R2, Stock020
	MOVB [R2], R1
;INICIALIZAÇAO DO STOCK DE MOEDAS DE 10 CENTS
	MOV R1, 200
	MOV R2, Stock010
	MOVB [R2], R1		

	CALL MoverStockAuxstock 	;inicializar os stocks auxiliares  de DINHEIRO com os valores dos stocks reais
	
; ************** FIM DA INICIALIZACAO DE STOCKS ***********************	
	
;----------------------;
;  PROGRAMA PRINCIPAL  ;    
;----------------------;                      
                                                                             
ProgramaPrincipal:
	CALL LimparRegistos				;Limpa os registos
	CALL LimparDisplay				;Limpa o display
	CALL LimparPerifericoSelecao	;Limpa valores do periferico de seleçao
	CALL LimparPerifericosInput		;Limpa valores do periferico de input (introduçao moedas/notas para pagamento)
	CALL LimparPerifericosOutput	;Limpa valores do periferico de output (periferico que indica quantas moedas/notas de cada valor sao devolvidas como troco)
	
    CALL RotinaMenuPrincipal		;Rotina que trata dos menus e da navegaçao
	
	CMP R8, 1					;R8 contem variavel de controle que diz que foi escolhida uma opçao errada no menu
	JZ ErroOpcaoErrada
	
    CALL RotinaCompra			;Rotina que trata do troco , do pagamento e da alteraçao dos stocks
	
	CMP R9, 1 					;R9 contem variavel de controle que diz que se havia stock da bebida em questao ou nao
	JZ	ErroNaoHaStock
	
	CMP R10, 0					;Dinheiro Introduzido MENOR que o preço do item,logo a compra NAO é possivel
	JZ ErroInputInsuficiente
	
	CMP R10, 1					;Dinheiro Introduzido IGUAL ao preço do item, logo a compra É possivel
	JZ CompraPossivel
	
	CMP R10, 2					;NAO foi possivel dar troco, logo a compra NAO é possivel
	JZ	ErroNaoHaTroco
	
	CMP R10, 3					;FOI possivel dar troco, logo a compra É possivel
	JZ	CompraPossivel
	
ErroOpcaoErrada:
	MOV R7, OpcaoErrada			;Move para R7 a palavra a ser mostrada na notificaçao "Opcao errada"
	JMP EscreverErros
	
ErroInputInsuficiente:
	MOV R7, DinheiroInsuficiente	;Move para R7 a palavra a ser mostrada na notificaçao "Dinheiro insuf"
	JMP EscreverErros
	
ErroNaoHaTroco:
	MOV R7, NaoHaTroco			;Move para R7 a palavra a ser mostrada na notificaçao "Nao ha troco"
	JMP EscreverErros
	
ErroNaoHaStock:
	MOV R7, NaoHaStock			;Move para R7 a palavra a ser mostrada na notificaçao "Nao tem stock;
	JMP EscreverErros
	
EscreverErros:
	CALL MostraNotificacao		;MostraNotificaçao , escreve "Atençao" juntamente com a palavra guarda previamente em R7
	JMP Espera
		
CompraPossivel:	
    CALL RotinaImprimirTalao	;Rotina que imprime o talao
	
Espera:							;Rotina para o display ficar "preso" no talao ou na notificaçao de erro ate o periferico de seleçao passar a 1
	CALL UpdateStockBebida
	CALL EscreveStockEmDisplay
	CALL AlteraStockDisplay	
	CALL LimparPerifericoSelecao
	CALL RotinaLerOpcaoSelecao		
	CMP R0, 1			;Compara a opçao de seleçao com o valor 1
	JNZ Espera			;Se nao for 1 a rotina entra em ciclo
	
    JMP ProgramaPrincipal       ; Programa Principal funciona em loop

; ************** FIM DO PROGRAMA PRINCIPAL ***********************
	
;-------------------------;
;  Rotina: MENUPRINCIPAL  ;
;-------------------------;   

RotinaMenuPrincipal:
    CALL LimparPerifericoSelecao	;Limpa o periferico de seleçao
    CALL LimparDisplay              ; Limpa do display 
    MOV  R0, MENUPRINCIPAL          ; Coloca em R0 o menu que ira ser mostrado
    CALL EscreveDisplay         	; Chama a rotina EscreveDisplay para preencher o display com o respectivo menu em R0
    CALL RotinaLerOpcaoSelecao      ; Lê a opção escolhida pelo utilizador
    
    ;-- Verificação da primeira opção - BEBIDAS SEM GAS --;
    CMP R0, BebidasSemGas           ; Verifica se a primeira opção foi selecionada
    JZ RotinaBebidaSemGas           ; Vai para a rotina MenuAlmoco se a opção foi selecionada
    
    ;-- Verificação da segunda opção - BEBIDAS COM GAS --;
    CMP R0, BebidasComGas           ; Verifica se a segunda opção foi selecionada
    JZ RotinaBebidaComGas           ; Vai para a rotina MenuAlmoco se a opção foi selecionada
    
	MOV R8, 1		;Caso nao tenha selecionado nenhum opçao correcta , a variavel de controle ficar com valor 1 e retorna ao programa principal onde vai ser apresentada a msg de erro
	JMP RetornarProgramaPrincipal
           
;--------------------------;
;  Rotina BEBIDAS SEM GAS  ;
;--------------------------;
   
RotinaBebidaSemGas:
    CALL LimparPerifericoSelecao    ; Chama a rotina para limpar o periferico de escolhas previas
    CALL LimparDisplay       		; Chama a rotina para limpar o ecrã de posiveis mensagems antigas
    MOV  R0, MENUBSG         		; Passa para R0 os strings do Menu das bebidas sem gas   
    CALL EscreveDisplay 			; Chama a rotina EscreveDisplay para preencher o display com o respectivo menu em R0
    CALL RotinaLerOpcaoSelecao      ; Lê a opção escolhida pelo utilizador
    
    ;-- Verificação da primeira opção - COMPAL --;
    CMP R0, Compal              	;Compara se a opçao selecionada foi a opçao Compal
    MOV R1, StockCompal				;Guarda em R1 o endereço do stock de Compal
    MOV R3, PrecoCompal				;Guarda em R3 o preco da bebida
    JZ  RetornarProgramaPrincipal
    
    ;-- Verificação da segunda opção - AGUA --;
    CMP R0, Agua					;Compara se a opçao selecionada foi a opçao Agua
    MOV R1, StockAgua				;Guarda em R1 o endereço do stock de Agua
    MOV R3, PrecoAgua				;Guarda em R3 o preco da bebida
    JZ  RetornarProgramaPrincipal
    
    ;-- Verificação da terceira opção - REDBULL --;
    CMP R0, Redbull					;Compara se a opçao selecionada foi a opçao Redbull
    MOV R1, StockRedbull			;Guarda em R1 o endereço do stock de Redbull
    MOV R3, PrecoRedbull			;Guarda em R3 o preco da bebida
    JZ  RetornarProgramaPrincipal
    
    ;-- Verificação da quarta opção - VOLTAR --;
    CMP R0, Voltar					;Compara se a opçao selecionada foi a opçao Voltar
    JZ RotinaMenuPrincipal			;Se sim volta para a rotina menu principal
    
	MOV R8, 1		;Caso nao tenha selecionado nenhum opçao correcta , a variavel de controle ficar com valor 1 e retorna ao programa principal onde vai ser apresentada a msg de erro
	JMP RetornarProgramaPrincipal

;**** FIM DA ROTINA BEBIDAS SEM GAS ********

;--------------------------;
;  Rotina BEBIDAS COM GAS  ;
;--------------------------;
   
RotinaBebidaComGas:
    CALL LimparPerifericoSelecao    ; Chama a rotina para limpar o periferico de escolhas previas
    CALL LimparDisplay      		; Chama a rotina para limpar o ecrã de posiveis mensagems antigas
    MOV  R0, MENUBCG         		; Passa para R0 os strings do Menu das bebidas com gas   
    CALL EscreveDisplay  			; Chama a rotina EscreveDisplay para preencher o display com o respectivo menu em R0
    CALL RotinaLerOpcaoSelecao      ; Lê a opção escolhida pelo utilizador
    
    ;-- Verificação da primeira opção - COLA --;
    CMP R0, Cola					;Compara se a opçao selecionada foi a opçao Cola
    MOV R1, StockCola				;Guarda em R1 o endereço do stock de Cola
    MOV R3, PrecoCola				;Guarda em R3 o preco da bebida
    JZ  RetornarProgramaPrincipal
    
    ;-- Verificação da segunda opção - FANTA --;
    CMP R0, Fanta					;Compara se a opçao selecionada foi a opçao Fanta
    MOV R1, StockFanta				;Guarda em R1 o endereço do stock de Fanta
    MOV R3, PrecoFanta				;Guarda em R3 o preco da bebida
    JZ  RetornarProgramaPrincipal
    
    ;-- Verificação da terceira opção - SPRITE --;
    CMP R0, Sprite					;Compara se a opçao selecionada foi a opçao Sprite
    MOV R1, StockSprite				;Guarda em R1 o endereço do stock de Sprite
    MOV R3, PrecoSprite				;Guarda em R3 o preco da bebida
    JZ RetornarProgramaPrincipal
    
    ;-- Verificação da quarta opção - VOLTAR --;
    CMP R0, Voltar					;Compara se a opçao selecionada foi a opçao Voltar
    JZ RotinaMenuPrincipal
    
	MOV R8, 1		;Caso nao tenha selecionado nenhum opçao correcta , a variavel de controle ficar com valor 1 e retorna ao programa principal onde vai ser apresentada a msg de erro
	JMP RetornarProgramaPrincipal

;**** FIM DA ROTINA BEBIDAS COM GAS ********

;--------------------------------------------------;
;  Retonar ao ProgramaPrincipal a partir dos menus ;
;--------------------------------------------------;

RetornarProgramaPrincipal:
    RET  ;retorna ao programa principal 
     
;**** FIM DA ROTINA MENU PRINCIPAL ********
 
;-----------------------;
;   Rotina de COMPRA    ;  
;-----------------------;

RotinaCompra:
    MOVB R2, [R1]   		; guardar a qantidade de stock do item em questao no R1, o endereço do mesmo esta em R1
    CMP  R2, 0       		 ; Verifica se existe Stock
    JZ   NaoHaBebidaEmStock
	
	CALL LimparDisplay		;Limpa o display
	MOV  R0, AGUARDARPAG	;Move para R0 as strings q dizem "Aguardando Pagamento ..."
    CALL EscreveDisplay		;Escreve no display o que estava guardado em R0
    CALL RotinaPagamento   	;Rotina de pagamento 
	
	CMP R10, 0				;Verificamos o valor da variavel de controlo R10, que vem da RotinaTroco para determinar qual a proxima rotina a executar
	JZ  InputFoiMenorQuePreco
	CMP R10, 1
	JZ  InputFoiIgualPreco
	CMP R10, 2
	JZ	NaoFoiDadoTroco
	CMP R10, 3
	JZ	FoiDadoTroco

NaoHaBebidaEmStock:
	MOV R9, 1				;Variavel de controlo que indica se existia em stock a bebida escolhida, R9 = 1 indica que nao ha em stock
	JMP FimRotinaCompra
	
InputFoiMenorQuePreco:	
	CALL UpdatesIMP			;faz updates aos stocks e aos perifericos de input e output, caso o input ter sido menor que o preço do item
	JMP  FimRotinaCompra
	
InputFoiIgualPreco:	
    CALL UpdatesIIP			;faz updates aos stocks e aos perifericos de input e output, caso o input ter sido igual ao preço do item
	SUB  R2, 1      		;Decrementa 1 ao registo que tem a quantidade de stock de bebidas
    MOVB  [R1], R2    		;Copia do valor de R2 para o endereço do item, que esta em R1, actualizando a quantidade de stock do item, na memória.
	JMP  FimRotinaCompra
	
NaoFoiDadoTroco:
	CALL UpdatesNDT			;faz updates aos stocks e aos perifericos de input e output, caso nao ter dado troco (input foi maior que preço do item)
	JMP  FimRotinaCompra
	
FoiDadoTroco:
	CALL UpdatesDT			;faz updates aos stocks e aos perifericos de input e output, caso ter dado troco (input foi maior que preço do item)	
    SUB  R2, 1      		;Decrementa 1 ao registo que tem a quantidade de stock de bebidas
    MOVB  [R1], R2    		; Copia do valor de R2 para o endereço do item, que esta em R1, actualizando a quantidade de stock do item, na memória.
	JMP  FimRotinaCompra
	
FimRotinaCompra:
    RET
    
;**** FIM DA ROTINA COMPRA ******** 

;-----------------------;
;  Rotina de Pagamento  ;
;-----------------------;

RotinaPagamento:
    CALL LimparPerifericoSelecao
	CALL LimparPerifericosInput
	CALL LimparPerifericosOutput
    CALL LerInputDinheiro  			;Funcao que le os inputs de dinheiro e retorna o total inserido
    CALL RotinaTroco				
    RET  ; retorna a rotina de compra

;**** FIM DA ROTINA PAGAMENTO********

;----------------------------;
;  Ler Inputs de Dinheiro    ;
;----------------------------;

LerInputDinheiro:
    PUSH R1   
    PUSH R2 
    PUSH R3
	
    PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10
	
    CicloPD: 
    
    MOV R1, Selecao    ;guarda o enderço da informação selecao
    
    MOVB R1, [R1]      ; neste passo é que guarda o valor mesmo da selecao, que sera usado para comparar
    CMP R1, 0           ; compara se R1 Tem zero ou não, se não tiver é que tem algo selecionado e queremos avancar
    JZ CicloPD         ; se tem zero não selecionou nada e continua em loop
                       ; Caso tenha selecionado , le os inputs de dinheiro
                        
    MOV R5, Input500    ;Move endereços dos inputs para os registos
    MOV R6, Input200
    MOV R7, Input100
    MOV R8, Input050
    MOV R9, Input020
    MOV R10, Input010
    
    MOVB R5, [R5]   ;R5 tem agora o numero de vezes que a nota de 5 euros foi introduzida
    MOVB R6, [R6]   ;R6 tem agora o numero de vezes que a moeda de 2 euros foi introduzida
    MOVB R7, [R7]   ;R7 tem agora o numero de vezes que a moeda de 1 euros foi introduzida
    MOVB R8, [R8]   ;R8 tem agora o numero de vezes que a moeda de 50 centimos foi introduzida
    MOVB R9, [R9]   ;R9 tem agora o numero de vezes que a moeda de 20 centimos foi introduzida
    MOVB R10, [R10] ;R10 tem agora o numero de vezes que a moeda de 10 centimos foi introduzida
    
    MOV R2, Valor500  ; Move para R2 o valor 500
    MUL R5, R2        ; Multiplica o valor pelo numero de vezes que a nota foi inserida
    
    MOV R2, Valor200  ; Move para R2 o valor 200  
    MUL R6, R2        ; Multiplica o valor pelo numero de vezes que a moeda foi inserido
    
    MOV R2, Valor100  ; Move para R2 o valor 100  
    MUL R7, R2        ; Multiplica o valor pelo numero de vezes que a moeda foi inserido
    
    MOV R2, Valor050   ; Move para R2 o valor 50   
    MUL R8, R2        ; Multiplica o valor pelo numero de vezes que a moeda foi inserido
    
    MOV R2, Valor020   ; Move para R2 o valor 20
    MUL R9, R2        ; Multiplica o valor pelo numero de vezes que a moeda foi inserido
    
    MOV R2, Valor010   ; Move para R2 o valor 10
    MUL R10, R2       ; Multiplica o valor pelo numero de vezes que a moeda foi inserido
    
    ADD R4, R5   ;Soma em R4 todas as ocorrencias da nota de 5 euros
    ADD R4, R6   ;Soma em R4 todas as ocorrencias da moeda de 2 euros
    ADD R4, R7   ;Soma em R4 todas as ocorrencias da moeda de 1 euros
    ADD R4, R8   ;Soma em R4 todas as ocorrencias da moeda de 50 centimos
    ADD R4, R9   ;Soma em R4 todas as ocorrencias da moeda de 20 centimos
    ADD R4, R10  ;Soma em R4 todas as ocorrencias da moeda de 10 centimos
    
	;R4 vai ter o valor da soma total do dinheiro introduzido pelo utilizador
	
	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	
    POP R3
    POP R2
    POP R1
    RET         ; volta para a rotina de pagamento
    
;**** FIM DA ROTINA LER PERIFERICO DINHEIRO********   

;----------------;
;  Rotina Troco  ;
;----------------;

RotinaTroco:
    PUSH R1
    PUSH R2
    PUSH R5
    PUSH R6
    
    ;R3 contem o custo da bebida em questao
    ;R4 contem o valor total introduzido pelo utilizador
    
	CMP R4, R3					;Comparamos o Input de dinheiro com o custo da bebida
    JLT InputMenorQuePreco		;Se Input for menor que preço da bebida , salta para a etiqueta "InputMenorQuePreço"
    JZ  InputIgualPreco			;Se Input fori gual ao preço da bebida , salta para a etiqueta "InputIgualPreço"
		
    SUB R4, R3                      ;Guarda em R4 o troco total que o utilizador tem a receber
    
VerificaTroco5euros:                ;Rotina que verifica se é necessario dar nota de 5 euros como troco
    MOV R2, AuxStock500             ;Guarda endereço da copia do stock em R2 
    MOVB R6, [R2]                   ;Guarda em R6 o valor da copia do stock
    CMP R6, 0                        ;Verifica se o valor da copia do stock é zero
    JZ VerificaTroco2euros          ;Se for zero verifica a proxima moeda
    MOV R1, Valor500                ;Coloca em R1 o valor 500
    CMP R4, R1                      ;Verifica se o troco a dar é menor que 500 (nota 5 euros)
    JLT VerificaTroco2euros         ;Caso seja menor que 500, vai verificar se é necessario dar troco com moedas de 2 euros
    MOV R5, Output500                ;Guarda o endereço com o output de notas de 5 euros
    CALL DecrementaStockTroco       ;Decrementa o stock(copia) e o troco total que o utilizador tem de receber
    JMP VerificaTroco5euros         ;Verificamos de novo se é necessario dar nota de 5 euros como troco
    
VerificaTroco2euros:                ;Rotina que verifica se é necessario dar moeda de 2 euros como troco
    MOV R2, AuxStock200             ;Guarda endereço da copia do stock em R2 
    MOVB R6, [R2]                   ;Guarda em R6 o valor da copia do stock
    CMP R6, 0                        ;Verifica se o valor da copia do stock é zero
    JZ VerificaTroco1euro           ;Se for zero verifica a proxima moeda
    MOV R1, Valor200                ;Coloca em R1 o valor 200
    CMP R4, R1                      ;Verifica se o troco a dar é menor que 200 (moeda 2 euros)
    JLT VerificaTroco1euro          ;Caso seja menor que 200, vai verificar se é necessario dar troco com moedas de 1 euro
    MOV R5, Output200                ;Guarda o endereço com o output de moedas de 2 euros
    CALL DecrementaStockTroco       ;Decrementa o stock(copia) e o troco total que o utilizador tem de receber
    JMP VerificaTroco2euros         ;Verificamos de novo se é necessario dar moeda de 2 euros como troco
  
VerificaTroco1euro:                 ;Rotina que verifica se é necessario dar moeda de 1 euro como troco
    MOV R2, AuxStock100             ;Guarda endereço da copia do stock em R2
    MOVB R6, [R2]                   ;Guarda em R6 o valor da copia do stock
    CMP R6, 0                        ;Verifica se o valor da copia do stock é zero
    JZ VerificaTroco50cents         ;Se for zero verifica a proxima moeda
    MOV R1, Valor100                ;Coloca em R1 o valor 100
    CMP R4, R1                      ;Verifica se o troco a dar é menor que 100 (moeda 1 euros)
    JLT VerificaTroco50cents        ;Caso seja menor que 100, vai verificar se é necessario dar troco com moedas de 50 centimos
    MOV R5, Output100                ;Guarda o endereço com o output de moedas de 1 euro
    CALL DecrementaStockTroco       ;Decrementa o stock(copia) e o troco total que o utilizador tem de receber
    JMP VerificaTroco1euro          ;Verificamos de novo se é necessario dar moeda de 1 euro como troco
    
VerificaTroco50cents:               ;Rotina que verifica se é necessario dar moeda de 50 cents como troco
    MOV R2, AuxStock050             ;Guarda endereço da copia do stock em R2 
    MOVB R6, [R2]                   ;Guarda em R6 o valor da copia do stock
    CMP R6, 0                        ;Verifica se o valor da copia do stock é zero
    JZ VerificaTroco20cents         ;Se for zero verifica a proxima moeda
    MOV R1, Valor050                ;Coloca em R1 o valor 50
    CMP R4, R1                      ;Verifica se o troco a dar é menor que 50 (moeda 50 cents)
    JLT VerificaTroco20cents        ;Caso seja menor que 50, vai verificar se é necessario dar troco com moedas de 20 cents
    MOV R5, Output050                ;Guarda o endereço com o output de moedas de 50 cents
    CALL DecrementaStockTroco       ;Decrementa o stock(copia) e o troco total que o utilizador tem de receber
    JMP VerificaTroco50cents        ;Verificamos de novo se é necessario dar moeda de 50 cents como troco

VerificaTroco20cents:               ;Rotina que verifica se é necessario dar moeda de 20 centimos como troco
    MOV R2, AuxStock020             ;Guarda endereço da copia do stock em R2
    MOVB R6, [R2]                   ;Guarda em R6 o valor da copia do stock
    CMP R6, 0                        ;Verifica se o valor da copia do stock é zero
    JZ VerificaTroco10cents         ;Se for zero verifica a proxima moeda
    MOV R1, Valor020                ;Coloca em R1 o valor 20
    CMP R4, R1                      ;Verifica se o troco a dar é menor que 20 (moeda de 20 centimos)
    JLT VerificaTroco10cents        ;Caso seja menor que 20, vai verificar se é necessario dar troco com moedas de 10 centimos
    MOV R5, Output020                ;Guarda o endereço com o output de moedas de 20 centimos
    CALL DecrementaStockTroco       ;Decrementa o stock(copia) e o troco total que o utilizador tem de receber
    JMP VerificaTroco20cents        ;Verificamos de novo se é necessario dar moeda de 20 centimos como troco
   
VerificaTroco10cents:               ;Rotina que verifica se é necessario dar moeda de 10 centimos como troco
    MOV R2, AuxStock010             ;Guarda endereço da copia do stock em R2
    MOVB R6, [R2]                   ;Guarda em R6 o valor da copia do stock
    CMP R6, 0                        ;Verifica se o valor da copia do stock é zero
    JZ FimRotinaTroco               ;Se for zero salta para o FimRotinaTroco
    MOV R1, Valor010                ;Coloca em R1 o valor 10
    CMP R4, R1                      ;Verifica se o troco a dar é menor que 10 (moeda de 10 centimos)
    JLT FimRotinaTroco              ;Caso seja menor que 10 salta para o FimRotinaTroco
    MOV R5, Output010               ;Guarda o endereço com o output de moedas de 10 cents
    CALL DecrementaStockTroco       ;Decrementa o stock(copia) e o troco total que o utilizador tem de receber
    JMP VerificaTroco10cents        ;Verificamos de novo se é necessario dar moeda de 10 cents como troco

FimRotinaTroco:
;Utilizamos R10 para identificar se o Input é menor, igual ou maior que o preço (quando for maior verificamos se foi possivel dar troco ou nao)

    CMP R4, 0			;Verificamos se o troco a dar ao utilizador é zero 	
	
    JZ DeuTroco		;Se for igual a zero quer dizer que foi possivel dar troco, salta para a DeuTroco
	
	MOV R10, 2		;Como nao foi possive dar troco a variavel de controle R10 é igualada a 2
	JMP SairRotinaTroco
	
DeuTroco:	
	MOV R10, 3			;Como  foi possivel dar troco, a variavel de controle R10 é igualada a 3
	JMP SairRotinaTroco
	
InputMenorQuePreco:		
	MOV R10, 0			;Como o Input de dinheiro foi menor que o preço do item , R10 é igualado a 0
	JMP SairRotinaTroco
	
InputIgualPreco:
	MOV R10, 1			;Como o Input de dinheiro foi igual ao preço do item , R10 é igualado a 1
	JMP SairRotinaTroco
	
SairRotinaTroco:
	POP R6
    POP R5
    POP R2
    POP R1
    RET         		;Volta para a rotina de pagamento
    
;**** FIM DA ROTINA TROCO ********

;---------------------------------;
; Rotina Decrementa Stock e Troco ;decrementa stock(copia) e decrementa troco total a recebeber pelo user
;---------------------------------;
;R1 - Valor da moeda/nota
;R2 - endereço com a copia do stock
;R4 - troco que o utilizador tem a receber
;R5 - endereço do output do troco
;R6 - valor da copia do stock

DecrementaStockTroco:
    PUSH R7
    
    SUB R6, 1           ; decrementa o valor da copia do stock da moeda/nota
    MOVB R7, [R5]       ; guarda em R7 o output da moeda/nota deste tipo (numero de vezes que a moeda sera devolvida)
    ADD R7, 1           ; incrementa 1 valor a R7 (adiciona mais uma moeda/nota deste tipo a ser devolvida)
    MOVB [R5], R7       ; copia o valor em R7 para a celula de output do troco (deste tipo de moeda/nota)
    MOVB [R2], R6       ; copia o valor em R6 para a cecula q contem a copia do stock
    SUB R4, R1          ; Subtrai do troco a ser recebido pelo user, o valor desta moeda/nota
    
    POP R7
    RET   ; volta para a rotina troco
 
;**** FIM DA ROTINA DECREMENTA STOCK E TROCO********

;-------------------------;
;  Actualizaçoes nos stocks I/O caso input de dinheiro tenha sido MENOR que preço do item  ;
;-------------------------;
UpdatesIMP:  ;valores de Input passam para os outputs (dinheiro introduzido é devolvido), inputs sao limpos
	CALL CopiarInputParaOutput
	CALL LimparPerifericosInput
	RET

;******FIM DA ROTINA ACTUALIZA STOCKS IMP**********

;-------------------------;
;  Actualizaçoes nos stocks I/O caso input de dinheiro tenha sido IGUAL ao preço do item  ;
;-------------------------;
UpdatesIIP:   ;é somado ao stock de moedas os valores dos inputs, inputs e outputs sao limpos
	CALL SomaInputsStocksMoedas
	CALL LimparPerifericosInput
	CALL LimparPerifericosOutput
	CALL MoverStockAuxstock			;O stock real foi alterado , logo é preciso actualizar o stock auxiliar
	RET
	
;******FIM DA ROTINA ACTUALIZA STOCKS IIP**********

;-------------------------;
;  Actualizaçoes nos stocks I/O caso NAO tenha sido dado troco  ;
;-------------------------;
UpdatesNDT:		;valores do stock auxiliar sao copiados para o valor do stock real, é somado so stock de moedas real os valores dos inputs, inputs sao limpos
	CALL MoverStockAuxstock
	CALL CopiarInputParaOutput
	CALL LimparPerifericosInput
	RET
	
;******FIM DA ROTINA ACTUALIZA STOCKS NDT**********

;-------------------------;
;  Actualizaçoes nos stocks I/O caso TENHA SIDO DADO TROCO  ;
;-------------------------;
UpdatesDT:		;como nao foi dado troco temos de igualar o stock auxiliar ao stock real , os valores de input passam para output , inputs sao limpos
	CALL MoverAuxstockStock
	CALL SomaInputsStocksMoedas
	CALL LimparPerifericosInput
	CALL MoverStockAuxstock			;O stock real foi alterado , logo é preciso actualizar o stock auxiliar
	RET
	;O output de moedas foi calculado dentro da rotina troco
	
;******FIM DA ROTINA ACTUALIZA STOCKS DT**********

;-----------------------;
; Rotina Imprimir Talão ;
;-----------------------;
RotinaImprimirTalao:
	PUSH R0
	PUSH R6
;Visto que os endereços de stocks sao unicos e que R1 contem o endeço de stock da bebida selecionada
;Vamos comparar	os valores para escolher qual dos taloes é que vai ser impresso

	MOV R6, StockCompal		;Move endereço do stock da respectiva bebida para R6
	CMP R1, R6				;compara se a selecao de bebida foi compal			
	JZ  RotinaTalaoCompal	;Caso sejam iguais , salta para a rotina que vai escrever o talao

	MOV R6, StockAgua		;Move endereço do stock da respectiva bebida para R6
	CMP R1, R6				;compara se a selecao de bebida foi Agua			
	JZ  RotinaTalaoAgua		;Caso sejam iguais , salta para a rotina que vai escrever o talao

	MOV R6, StockRedbull	;Move endereço do stock da respectiva bebida para R6
	CMP R1, R6				;compara se a selecao de bebida foi Redbull		
	JZ  RotinaTalaoRedbull	;Caso sejam iguais , salta para a rotina que vai escrever o talao

	MOV R6, StockCola		;Move endereço do stock da respectiva bebida para R6
	CMP R1, R6				;compara se a selecao de bebida foi Cola			
	JZ  RotinaTalaoCola		;Caso sejam iguais , salta para a rotina que vai escrever o talao

	MOV R6, StockFanta		;Move endereço do stock da respectiva bebida para R6
	CMP R1, R6				;compara se a selecao de bebida foi Fanta			
	JZ  RotinaTalaoFanta	;Caso sejam iguais , salta para a rotina que vai escrever o talao

	MOV R6, StockSprite		;Move endereço do stock da respectiva bebida para R6
	CMP R1, R6				;compara se a selecao de bebida foi Sprite			
	JZ  RotinaTalaoSprite	;Caso sejam iguais , salta para a rotina que vai escrever o talao	
		
RotinaTalaoCompal:
    MOV R0, TALAOCOMPAL		;Coloca em R0 o respectivo talao
	JMP ImprimirTalao
	
RotinaTalaoAgua:
    MOV R0, TALAOAGUA		;Coloca em R0 o respectivo talao
	JMP ImprimirTalao
	
RotinaTalaoRedbull:
    MOV R0, TALAOREDBULL	;Coloca em R0 o respectivo talao
	JMP ImprimirTalao
	
RotinaTalaoCola:
    MOV R0, TALAOCOLA		;Coloca em R0 o respectivo talao
	JMP ImprimirTalao
	
RotinaTalaoFanta:
    MOV R0, TALAOFANTA		;Coloca em R0 o respectivo talao
	JMP ImprimirTalao
	
RotinaTalaoSprite:
    MOV R0, TALAOSPRITE		;Coloca em R0 o respectivo talao
	JMP ImprimirTalao

ImprimirTalao:
	CALL LimparDisplay		;Limpar o Display
	CALL EscreveDisplay		;Escreve no display o talao guardado em R0
	
	POP R6
	POP R0
	RET
	
;**** FIM DA ROTINA IMPRIMIR TALAO******** 

;--------------------------------------;
;  Rotina que limpa todos os registos  ;
;--------------------------------------;
LimparRegistos:
    MOV R0, 0
    MOV R1, 0
    MOV R2, 0
    MOV R3, 0
    MOV R4, 0
    MOV R5, 0
    MOV R6, 0
    MOV R7, 0
    MOV R8, 0
    MOV R9, 0
    MOV R10, 0
    MOV R11, 0
    
    RET
	
;******FIM DA ROTINA LIMPAR REGISTOS**********	

;-----------------------------;
;Rotina que mostra Notificacao;
;-----------------------------;
;A String apresentada tem de estar previamente guardadae em R7

MostraNotificacao:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
   
	CALL LimparDisplay
    
    MOV R1, Display            ; endereço onde começa a aparecer Display
    MOV R2, FimDisplay         ; endereço onde acaba
    MOV R3, NumCaracteres      ; constante com valor de apenas 1 linha de display
    
    MOV R4, Notificacao        ; a mensagem atencao
    MOV R0, 0                  ; inicializacao de indice, para comparar com a constante NumCaracteres
    
CicloMostraAtencao:
    MOVB R5, [R4]               ; vai buscar a string atencao
    MOVB [R1], R5               ; passa o caracter po display
    ADD R4, 1                   ; incrementa
    ADD R1, 1                   ;
    ADD R0, 1                   ;
    CMP R0, R3                  ; comparacao se o indice ja chegou ao final da linha
    JNZ CicloMostraAtencao
    
    MOV R6, R7                  ; passa para R7 o endereço com o erro
    MOV R0, 0                   ; inicializa o indice de novo a 0
    
CicloMostraErro:
    MOVB R5, [R6]               ; passa para R5, o valor que esta dentro do endereço (ou seja um caracter qualquer)
    MOVB [R1], R5               ; poem agora no display o caracter em questao
    ADD R6, 1                   ; incrementa o endereço para passarmos para o proximo caracter
    ADD R1, 1                   ; incrementa o endereço do display (ou seja estamos a passar po quadradinho ao lado para escrever)
    ADD R0, 1                   ; incrementa o indice
    CMP R0, R3                  ; comparacao se chegamos ao fim da linha
    JNZ CicloMostraErro         ; loop se nao chegarmos
        
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    
    RET
	
;******FIM DA ROTINA MOSTRA NOTIFICAÇAO**********	

;---------------------;
;Rotina limpar display;
;---------------------;

LimparDisplay:
	PUSH R0            ;rotina para limpar display da maquina
    PUSH R1               ; guarda a variavel previamente no registo 1
    PUSH R2               ;                               no registo 2
    PUSH R3               ;                               no registo 3
    
    MOV R0, Display       ; contem o endereço de onde começa o "ecra" de display   
    MOV R1, FimDisplay    ; valor que "sabe" onde acaba o display inicial
    MOV R2, CaracterVazio ; caracter vazio para preencher o ecra

CicloLimparDisplay:
    MOVB [R0], R2          ; acto que poem caracteres vazios
    ADD R0, 1              ; acto que faz andar 1 byte
    CMP R0, R1             ; comparar se ja chegou ao fim do display
    JNZ CicloLimparDisplay ; se não chegou ao fim continua a limpar
    
    POP R3                 ;Repoem Registo 3 anterior 
    POP R2                 ;               2
    POP R1                 ;               1
	POP R0
    RET

;******FIM DA ROTINA LIMPAR DISPLAY********** 

;-----------------------------;
;Rotina ler Periferico selecao;
;-----------------------------;

RotinaLerOpcaoSelecao:         ;rotina para ler a informaçao selecionada
    PUSH R1             

    CicloOpcao:
    MOV R1, Selecao    ;guarda o enderço da informação selecao
    
    MOVB R1, [R1]      ; neste passo é que guarda o valor mesmo da selecao, que sera usado para comparar
    CMP R1, 0           ; compara se R1 Tem zero ou não, se não tiver é que tem algo selecionado e queremos avancar
    JZ CicloOpcao      ; se tem zero não selecionou nada e continua em loop
    MOV R0, R1         ; R0 passa a ter o valor de selecao
    
    POP R1
    RET

;******FIM DA ROTINA LER PERIFERICO DE SELEÇAO **********    

;----------------------------------;
; Rotina limpar periferico Selecao ;
;----------------------------------;

LimparPerifericoSelecao:
    PUSH R0         ; guarda valor deste registo
    PUSH R1         ; same
    
    MOV  R0, 0
    MOV	 R1, Selecao ;
    MOVB [R1], R0    ; limpa o valor do periferico, ao colocar 0 na memoria de selecao
    
    POP R1          ;repoem os antigos valores para o registo
    POP R0          ; same
    RET

 ;******FIM DA ROTINA LIMPAR PERIFERICO DE SELEÇAO**********    
 
;---------------------------------------;
;  Rotina: Limpar Perifericos de Input  ;
;---------------------------------------;    
LimparPerifericosInput:
    PUSH R0                     ; Guarda o valor dos registos que vai alterar
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
	PUSH R5
    PUSH R6
    
;poem em registos os endereços dos inputs
    MOV R0, 0                   
    MOV R1, Input500            
    MOV R2, Input200
    MOV R3, Input100
    MOV R4, Input050
    MOV R5, Input020
    MOV R6, Input010
    
    MOVB [R1], R0               ; Limpa o periferico dos inputs de dinheiro
    MOVB [R2], R0
    MOVB [R3], R0
    MOVB [R4], R0
    MOVB [R5], R0
    MOVB [R6], R0
                    
    POP R6				; Repoe o valor dos registos anteriores ao call desta rotina
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    
    RET  
	
 ;******FIM DA ROTINA LIMPAR PERIFERICOS DE INPUT**********  
 
;---------------------------------------;
;  Rotina: Limpar Perifericos de Output ;
;---------------------------------------;    
LimparPerifericosOutput:
    PUSH R0                     ; Guarda o valor dos registos que vai alterar
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
	PUSH R5
    PUSH R6

;poem em registos os endereços dos outputs de dinheiro
    MOV R0, 0                   ;
    MOV R1, Output500           ;
    MOV R2, Output200
    MOV R3, Output100
    MOV R4, Output050
    MOV R5, Output020
    MOV R6, Output010
    
    MOVB [R1], R0               ; Limpa o periferico Output
    MOVB [R2], R0
    MOVB [R3], R0
    MOVB [R4], R0
    MOVB [R5], R0
    MOVB [R6], R0

    POP R6
    POP R5						; Repoe o valor dos registos anteriores ao call desta rotina
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    
    RET

;******FIM DA ROTINA LIMPAR PERIFERICOS DE INPUT********** 
 
;---------------------------------------------------;
; Rotina que copia valores dos Inputs para Outputs  ;
;---------------------------------------------------;
CopiarInputParaOutput:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11
    
;mover endereços dos input para registos
    MOV R0, Input500
    MOV R1, Input200
    MOV R2, Input100
    MOV R3, Input050
    MOV R4, Input020
    MOV R5, Input010
    
;mover endereços dos output para registos
    MOV R6, Output500
    MOV R7, Output200
    MOV R8, Output100
    MOV R9, Output050
    MOV R10, Output020
    MOV R11, Output010
    
;mover valor que esta no endereço de inputs para registo
    MOVB R0, [R0]
    MOVB R1, [R1]
    MOVB R2, [R2]
    MOVB R3, [R3]
    MOVB R4, [R4]
    MOVB R5, [R5]
    
;mover para dentro do endereço dos outputs o valor que estava dentro dos endereços do input 
    MOVB [R6], R0
    MOVB [R7], R1
    MOVB [R8], R2
    MOVB [R9], R3
    MOVB [R10], R4
    MOVB [R11], R5
    
    POP R11
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    
    RET
	
;******FIM DA ROTINA COPIAR INPUTS PARA OUTPUTS**********
 
;--------------------------------------------------;
; Rotina que soma valores de Input ao StockMoedas  ;   
;--------------------------------------------------;
SomaInputsStocksMoedas:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11
    
;mover endereços dos inputs para registos
    MOV R0, Input500
    MOV R1, Input200
    MOV R2, Input100
    MOV R3, Input050
    MOV R4, Input020
    MOV R5, Input010
    
;mover endereços dos stocks para registos
    MOV R6, Stock500
    MOV R7, Stock200
    MOV R8, Stock100
    MOV R9, Stock050
    MOV R10, Stock020
    MOV R11, Stock010
    
;mover valor que esta na celula de endereço de inputs para registo
    MOVB R0, [R0]
    MOVB R1, [R1]
    MOVB R2, [R2]
    MOVB R3, [R3]
    MOVB R4, [R4]
    MOVB R5, [R5]
    
;mover valor que esta na celula de endereço dos stocks para registo
    MOVB R6, [R6]
    MOVB R7, [R7]
    MOVB R8, [R8]
    MOVB R9, [R9]
    MOVB R10, [R10]
    MOVB R11, [R11]
    
;somar aos stocks as moedas que estavam no input
    ADD R6, R0
    ADD R7, R1
    ADD R8, R2
    ADD R9, R3
    ADD R10, R4
    ADD R11, R5

;rechamar os enderecos dos stocks para estes novos registos
    MOV R0, Stock500
    MOV R1, Stock200
    MOV R2, Stock100
    MOV R3, Stock050
    MOV R4, Stock020
    MOV R5, Stock010
    
;mover para dentro da celula de endereço
    MOVB [R0], R6 
    MOVB [R1], R7 
    MOVB [R2], R8 
    MOVB [R3], R9 
    MOVB [R4], R10 
    MOVB [R5], R11 
      
    POP R11
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    
    RET
	
;******FIM DA ROTINA SOMA INPUTS AO STOCK DE MOEDAS**********

;-----------------------------------------------------------------;
; Rotina que copia valores de Stocks auxiliares para Stocks reais ;
;-----------------------------------------------------------------;
MoverAuxstockStock:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11
    
;mover endereços de stocks auxiliares para registos 
    MOV R0, AuxStock500
    MOV R1, AuxStock200
    MOV R2, AuxStock100
    MOV R3, AuxStock050
    MOV R4, AuxStock020
    MOV R5, AuxStock010
    
;mover endereços de stocks reais para registos
    MOV R6, Stock500
    MOV R7, Stock200
    MOV R8, Stock100
    MOV R9, Stock050
    MOV R10, Stock020
    MOV R11, Stock010

;mover valor que esta na celula de endereço dos stocks auxiliares para registos 
    MOVB R0, [R0]
    MOVB R1, [R1]
    MOVB R2, [R2]
    MOVB R3, [R3]
    MOVB R4, [R4]
    MOVB R5, [R5]
    
;mover este novo valor que estava no stock auxiliar para dentro do stock real
    MOVB [R6], R0
    MOVB [R7], R1
    MOVB [R8], R2
    MOVB [R9], R3
    MOVB [R10], R4
    MOVB [R11], R5
    
    POP R11
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    
    RET
	
;******FIM DA ROTINA COPIAR STOCK AUX PARA STOCK REAL**********
  
;---------------------------------------------------------------------;
; Rotina que copia valores dos Stocks reais para os Stocks auxiliares ;
;---------------------------------------------------------------------;
MoverStockAuxstock:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R11
    
;mover endereços de stocks auxiliares para registos 
    MOV R0, AuxStock500 ; guarda em registo r0 o endereço do stock auxiliar 500
    MOV R1, AuxStock200
    MOV R2, AuxStock100
    MOV R3, AuxStock050
    MOV R4, AuxStock020
    MOV R5, AuxStock010
    
;mover endereços de stocks reais para registos
    MOV R6, Stock500    ; guarda em R6 o endereço do stock real 500
    MOV R7, Stock200
    MOV R8, Stock100
    MOV R9, Stock050
    MOV R10, Stock020
    MOV R11, Stock010

;mover valor que esta na celula de endereço dos stocks reais para registos  
    MOVB R6, [R6]      ;mover o valor da celula endereçada por R6, para o registo R6
    MOVB R7, [R7]
    MOVB R8, [R8]
    MOVB R9, [R9]
    MOVB R10, [R10]
    MOVB R11, [R11]
    
;mover este novo valor que estava no stock real para dentro do stock auxiliar
    MOVB [R0], R6      ;move para o stock auxiliar o valor que estava no stock real
    MOVB [R1], R7
    MOVB [R2], R8
    MOVB [R3], R9
    MOVB [R4], R10
    MOVB [R5], R11
    
    POP R11
    POP R10
    POP R9
    POP R8
    POP R7
    POP R6
    POP R5
    POP R4
    POP R3
    POP R2
    POP R1
    POP R0
    
    RET

;******FIM DA ROTINA COPIAR STOCK REAL PARA STOCK AUX**********
 
;------------------------------;
;Rotina que escreve no display ;
;------------------------------;

EscreveDisplay:
    PUSH R1                ; guarda conteudos previos do registo
    PUSH R2
    PUSH R3
    
    MOV R1, Display        ;guarda o endereço do inicio do display
    MOV R2, FimDisplay     ;guarda o endereço do fim do display
    
CicloEscreveDisplay:
    MOVB R3, [R0]          ; agarra no caracter que esta na string e poem no R3
    MOVB [R1], R3           ; começa alterar o display caracter por caracter
    ADD R0, 1              ; Avança para o proximo caracter
    ADD R1, 1 
    CMP R1, R2             ; compara se ja chegou ao fim da posicao de display
    JNZ CicloEscreveDisplay
    
    POP R3                 ; repoe valores antigos nos respectivos registos
    POP R2
    POP R1
    
    RET

;******FIM DA ROTINA ESCREVE DISPLAY**********
  
;------------------------------------------;
; Rotina: converte para ascii stock Bebidas ; 
;------------------------------------------;

;R1 contem o endereço do valor que queremos imprimir (ou seja o endereço de stock em questao) falta confirmar se esta em R1 o auxstock ou stock real

UpdateStockBebida:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3

	 
	MOV R5, ENDdaBebida3ValorDecimal ; Endereco onde estara o valor a colocar no display da terceira casa decimal do stock bebidas

	MOV R6, ENDdaBebida2ValorDecimal ; Endereco onde estara o valor a colocar no display da segunda casa decimal do stock bebidas

	MOV R11, ENDdaBebida1ValorDecimal; Endereco onde estara o valor a colocar no display da primeira casa decimal do stock bebidas

	
	MOV R3, Ascii			; guarda em R3 o valor ascii (30h) para usar em converçoes
	MOVB R2, [R1]			; guarda em R2 o valor da stack que queremos imprimir

	
TerceiraCasaDecimal:	
	MOV R0, 100
	CMP R2, R0				; ver se o numero é menor que 100
	JLT SegundaCasaDecimal	; se sim, passa para a outra casa decimal
	DIV R2, R0				; divisao inteira do valor do stock por 100
	ADD R2, R3				; soma +30h a terceira casa decimal do stock em questao, para transformar em numero ascii
	MOVB [R5], R2


SegundaCasaDecimal:
	MOVB R2, [R1]			; temos que voltar a pedir o valor do stock em questao
	MOD R2, R0				; fazemos o modulo do stock por 100, para obter o valor para a proxima casa decimal
	MOV R0, 10				; novo valor a ser utilizado para a divisao
	CMP R2, R0				; ver se é menor que 10
	JLT PrimeiraCasaDecimal ; se sim salta para a ultima casa decimal
	DIV R2, R0				; divisao inteira do valor do stock por 10
	ADD R2, R3				; soma +30h a segunda casa decimal do stock em questao, para transformar em numero ascii
	MOVB [R6], R2
	
PrimeiraCasaDecimal:
	MOVB R2, [R1]			; temos que voltar a pedir o valor do stock em questao
	MOD R2, R0				; fazemos o modulo do stock por 10, para obter o valor para a proxima casa decimal
	MOV R0, 1				; novo valor a ser utilizado para a divisao
	DIV R2, R0				; divisao inteira do valor do stock por 1
	ADD R2, R3				; soma +30h a segunda casa decimal do stock em questao, para transformar em numero ascii
	MOVB [R11], R2
	
	POP R3
	POP R2
	POP R1
	POP R0
	
	RET
	
;------------------------------------------;
; Escreve no display Novo Valor para stock ;
;------------------------------------------;

EscreveStockEmDisplay:

	PUSH R1
	PUSH R2
	PUSH R5
	
	

	MOV R2, StockCompal
	CMP R2, R1
	JZ AlteraStockCompal
	
	MOV R2, StockAgua
	CMP R2, R1
	JZ AlteraStockAgua
	
	MOV R2, StockRedbull
	CMP R2, R1
	JZ AlteraStockRedbull
	
	MOV R2, StockCola
	CMP R2, R1
	JZ AlteraStockCola
	
	MOV R2, StockFanta
	CMP R2, R1
	JZ AlteraStockFanta
	
	MOV R2, StockSprite
	CMP R2, R1
	JZ AlteraStockSprite
	JMP TerminaEscreveStockEmDisplay
	
AlteraStockCompal:
	MOV R5, 10H 					; damos este valor a R5, porque queremos ir para a linha 2 do MENUSTOCK
	CALL  AlteraStockDisplay
	JMP TerminaEscreveStockEmDisplay
	
AlteraStockAgua:
	MOV R5, 20H						; damos este valor a R5, pk queremos ir para a linha 2 do MENUSTOCK
	CALL  AlteraStockDisplay
	JMP TerminaEscreveStockEmDisplay
	
AlteraStockRedbull:
	MOV R5, 30H						; damos este valor a R5, pk queremos ir para a linha 3 do MENUSTOCK
	CALL  AlteraStockDisplay
	JMP TerminaEscreveStockEmDisplay
	
AlteraStockCola:
	MOV R5, 40h						; damos este valor a R5, pk queremos ir para a linha 4 do MENUSTOCK
	CALL  AlteraStockDisplay
	JMP TerminaEscreveStockEmDisplay
	
AlteraStockFanta:
	MOV R5, 50H						; damos este valor a R5, pk queremos ir para a linha 5 do MENUSTOCK
	CALL  AlteraStockDisplay
	JMP TerminaEscreveStockEmDisplay
	
AlteraStockSprite:
	MOV R5, 60H						; damos este valor a R5, pk queremos ir para a linha 6 do MENUSTOCK
	CALL  AlteraStockDisplay
	JMP TerminaEscreveStockEmDisplay
	
TerminaEscreveStockEmDisplay:
	POP R5
	POP R2
	POP R1
	RET 
	
	
;-----------------------------------------------------------;
; Funcao que vai a Linha X do display stock, e altera stock ;
;-----------------------------------------------------------;
AlteraStockDisplay:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	
	MOV R0, MENUSTOCK			; chama o endereço que contem a string do MENUSTOCK
	MOV R2, 13					; poem em R2 a posicao da terceira casa decimal
	MOV R3, 0					; indice usado para percorer
	
Incrementador:
	ADD R3, 1
	CMP R3, R2					; verifica se o indice ja chegou ao lugar desejado
	JNZ Incrementador			; se não continua a incrementar
	
	MOV R1, ENDdaBebida3ValorDecimal	; busca o endereco que tem o valor da casa das centenas
	MOVB R1, [R1]				; passa para R1 o valor que esta neste endereço
	ADD R0, R5					; anda algumas linhas para baixo, valor do R5 vem da rotina EscreveStockEmDisplay, e sabe quantas linhas tera que descer para o stock em questao
	ADD R0, R3					; andamos agora 13 valores dentro desta linha de string, ate chegar ao caracter que representa casa das centenas
	MOVB [R0], R1				; escreve no display do stock este novo valor para a casa das centenas
	
	MOV R1, ENDdaBebida2ValorDecimal	; busca  endereco que tem o valor da casa das dezenas
	MOVB R1, [R1]				; passa para R1 o valor que esta neste endereço
	ADD R0, 1					; andamos um valor dentro da linha de string, que contem agora o caracter da casa das dezenas
	MOVB [R0], R1				; escreve no display do stock este novo valor para a casa das dezenas
	
	MOV R1, ENDdaBebida1ValorDecimal	; busca  endereco que tem o valor da casa das unidades
	MOVB R1, [R1]				; passa para R1 o valor que esta neste endereço
	ADD R0, 1					; andamos um valor dentro da linha de string, que contem agora o caracter da casa das unidades
	MOVB [R0], R1				; escreve no display do stock este novo valor para a casa das unidades
	
	POP R3
	POP R2
	POP R1
	POP R0
	
	RET
	
	
;---------;
; STRINGS ;
;---------;

PLACE 0130H		;posicao de memoria;
MENUSTOCK: 		
	STRING "    Stocks:     " 
	STRING "Compal.......100" 
	STRING "Agua.........100"
	STRING "Redbull......100" 
	STRING "Cola.........100"
	STRING "Fanta........100"
	STRING "Sprite.......100"
	STRING "5 Euros......100"
	STRING "2 Euros......100"
	STRING "1 Euro.......100"
	STRING "50 Cents.....100"
	STRING "20 Cents.....100"
	STRING "10 Cents.....100"
	
;!!!!!!!AGUARDAR PAGAMENTO!!!!!!! 

PLACE 2000H
AGUARDARPAG:
	STRING "                " 
	STRING "   AGUARDANDO   "
	STRING "   PAGAMENTO    "
	STRING "      ...       "
	STRING "                "
	STRING "                "
	
;!!!!!!!!!!MENUS!!!!!!!!!!!!!! 

PLACE 2100H
MENUPRINCIPAL:
	STRING "Bebidas:        " ;menu principal;
	STRING "1-  Sem Gas     "
	STRING "2-  Com Gas     "
	STRING "                "
	STRING "                "
	STRING "                "   
	
PLACE 2200H
MENUBSG:
	STRING "Sem Gas:        " ;sub-menu bebidas sem gas e seu preço;
	STRING "1-Compal    1.00"
	STRING "2-Agua      0.50"
	STRING "3-RedBull   1.70"
	STRING "4-Voltar        "
	STRING "                "  
	
PLACE 2300H
MENUBCG:
	STRING "Com Gas:        " ;sub-menu com bebidas com gas e seu preço;
	STRING "1-Cola      1.00"
	STRING "2-Fanta     1.00"
	STRING "3-Sprite    1.00"
	STRING "4-Voltar        "
	STRING "                "  
 
;!!!!!!!!!!TALOES!!!!!!!!!!!!!! 
    
PLACE 2400H
TALAOCOMPAL:
	STRING "TALAO DE COMPRA:"
	STRING "                "
    STRING "Bebida     Custo" 
    STRING "Compal      1.00"
    STRING "                "
    STRING "                "
  
PLACE 2500H
TALAOAGUA:
	STRING "TALAO DE COMPRA:"
	STRING "                "
    STRING "Bebida     Custo" 
    STRING "Agua        0.50"
    STRING "                "
    STRING "                "

    
PLACE 2600H
TALAOREDBULL:
	STRING "TALAO DE COMPRA:"
	STRING "                "
    STRING "Bebida     Custo"
    STRING "Redbull     1.70"
    STRING "                "
    STRING "                "
    
PLACE 2700H
TALAOCOLA:
	STRING "TALAO DE COMPRA:"
	STRING "                "
    STRING "Bebida     Custo" 
    STRING "Cola        1.00"
    STRING "                "
    STRING "                "
    
PLACE 2800H
TALAOFANTA:
	STRING "TALAO DE COMPRA:"
	STRING "                "
    STRING "Bebida     Custo"
    STRING "Fanta       1.00"
    STRING "                "
    STRING "                "
    
PLACE 2900H
TALAOSPRITE:
	STRING "TALAO DE COMPRA:"
	STRING "                "
    STRING "Bebida     Custo"
    STRING "Sprite      1.00"
    STRING "                "
    STRING "                "


	
;!!!!!!!!AVISOS E ERROS!!!!!!!

Notificacao:
	STRING "Atencao:        "
NaoHaStock:
	STRING "Nao tem stock   "
NaoHaTroco:
	STRING "Nao ha troco    "
DinheiroInsuficiente:
	STRING "Dinheiro insuf. "
OpcaoErrada:
	STRING "Opcao errada    "
