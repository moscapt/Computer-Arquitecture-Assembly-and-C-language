#include <reg51.h>

//Prototipos das fun�oes

void inicializarStocks(void);
void inicalizarPortas(void);
void ler_valor(unsigned int);
void TXD_data(unsigned char);
void ler_bebida(void);
void mydelay(unsigned int);
void checkTotalCusto(unsigned int, unsigned int);
void devolverTroco(unsigned int);
void darBebida(unsigned int);
void activarTransPortaSerial();
unsigned int calcularTroco(unsigned int, unsigned int);
void interrupcoes_init(void);
void external_int0(void);
void rodarMotor50(void);
void rodarMotor10(void);
void rodarMotor05(void);
void rodarMotorB1(void);
void rodarMotorB2(void);
void rodarMotorB3(void);
void rodarMotorB4(void);
void calibrarMotores(void);

//declara��o das variaveis globais

unsigned int estado;		//determina em que estado est� o programa

unsigned int total;			//total de dinheiro introduzido em centimos
unsigned int custo;			//custo da bebida selecionada
unsigned int bebida;		//bebida selecionada

unsigned int stock05;		//stock de moedas de 0,05
unsigned int stock10;		//stock de moedas de 0,10
unsigned int stock20;		//stock de moedas de 0,20
unsigned int stock50;		//stock de moedas de 0,50

unsigned int stockb1;		//Stock da bebida1
unsigned int stockb2;		//Stock da bebida2
unsigned int stockb3;		//Stock da bebida3
unsigned int stockb4;		//Stock da bebida4

//defini�ao dos Pinos

sbit sensor10 = P0^0;		//Pino do sensor do motor da moeda de 0,10 euros
sbit sensor50 = P0^1;		//Pino do sensor do motor da moeda de 0,50 euros
sbit sensor05 = P0^2;		//Pino do sensor do motor da moeda de 0,05 euros

sbit motor10 = P2^4;		//Pino do motor da moeda de 0,10 euros
sbit motor50 = P2^5;		//Pino do motor da moeda de 0,50 euros
sbit motor05 = P2^6;		//Pino do motor da moeda de 0,05 euros

sbit sensorb1 = P2^0;		//Pino do sensor do motor da bebida 1
sbit sensorb2 = P2^1;		//Pino do sensor do motor da bebida 2
sbit sensorb3 = P2^2;		//Pino do sensor do motor da bebida 3
sbit sensorb4 = P2^3;		//Pino do sensor do motor da bebida 4

sbit motorb1 = P3^4;		//Pino do motor da bebida 1
sbit motorb2 = P3^5;		//Pino do motor da bebida 2
sbit motorb3 = P3^6;		//Pino do motor da bebida 3
sbit motorb4 = P3^7;		//Pino do motor da bebida 4

sbit cancel = P3^2;			//Pino do bot�o Cancel

sbit pserial = P3^1;		//Pino da porta serial

//defini��o das constantes

#define custob1 80		//Custo da bebida1
#define custob2 100		//Custo da bebida2
#define custob3 120		//Custo da bebida3
#define custob4 150		//Custo da bebida4

void main (void)
{
	inicializarStocks();				//inicializa stocks de bebidas e moedas
	inicalizarPortas();					//inicializa valores das portas
	activarTransPortaSerial();	//activar transmissao da porta serial
	interrupcoes_init();				//inicializar interrup��es
	calibrarMotores();					//calibra os motores das bebidas e das moedas
	
	estado = 1;		//programa come�a no estado 1
	
	total = 0;		//valor total introduzido come�a em 0
	custo = 0;		//custo da bebida selecionada � 0 no inicio
	bebida = 0;		//no inicio n�o h� nenhuma bebida escolhida
	
	
	for(;;)		//ciclo infinito
	{

		switch(estado)
		{
			//estado de introdu��o de moedas e sele��o de bebida
			case 1:
				ler_valor(total);								//l� e acumula valor das moedas introduzidas
				TXD_data(total);							 	//escreve no display o valor total introduzido
				ler_bebida();										//l� a bebida escolhida e guarda o custo da mesma
				checkTotalCusto(total, custo);	//Verifica se o valor total de moedas introduzidas � maior que o custo da bebida escolhida, se for muda para o estado 2
				break;
			
			//estado de venda, devolve troco e d� a bebida escolhida
			case 2:
				devolverTroco(calcularTroco(total, custo)); 	//calcula o troco a dar e devolve esse mesmo troco
				darBebida(bebida);														//d� a bebida escolhida
				custo = 0;									//reset da variavel custo da bebida
				total = 0;									//reset do total de dinheiro introduzido
				bebida = 0;									//reset da variavel da bebida selecionada
				estado = 1;									//muda para o estado 1 para voltar a executar as fun�oes desse mesmo estado
				P1=0xFF;										//Reset dos pinos de sele��o de moedas e bebidas
				break;
		
			//estado executado ap�s o bot�o cancel ser pressionado
			case 3:
				devolverTroco(total);		//devolve o dinheiro total introduzido
				custo = 0;							//reset da variavel custo da bebida
				total = 0;							//reset do total de dinheiro introduzido
				bebida = 0;							//reset da variavel da bebida selecionada
				estado = 1;							//muda para o estado 1 para voltar a executar as fun�oes desse mesmo estado
				P1=0xFF;								//Reset dos pinos de sele��o de moedas e bebidas
				break;
	
		}

	}

}

void ler_valor(unsigned int valor)
{
	
	int y = 0;
	y = (P1&0x0F);	//introdu�ao de uma mascara, executa uma opera�ao AND bit a bit, passando para 0 os valores dos pinos referentes �s bebidas
									//desta forma sao apenas lidos os pinos referentes �s moedas
	
	switch(y)				//Y contem valores dos pinos referentes �s moedas (os das bebidas estao a 0), salta para um caso mediante a combina��o de bits
	{								//cada combina��o de bits equivale � sele��o de uma das moedas, esta combina��o est� em decimal
		
		case 15:								//0000 1111
			valor = valor + 0;		//N�o foram introduzidas moedas, somamos 0
			P1=0xFF;							//Reset dos pinos de sele��o de moedas e bebidas
			break;
		
		case 14:								//0000 1110 
			valor = valor + 5;		//Introduzida moeda 5 centimos, somamos 5
			stock05++;						//Adiciona uma moeda ao stock de 5 centimos
			P1=0xFF;							//Reset dos pinos de sele��o de moedas e bebidas
			mydelay(20000);
			break;
		
		case 13:								//0000 1101 
			valor = valor + 10;		//Introduzida moeda 10 centimos, somamos 10
			stock10++;						//Adiciona uma moeda ao stock de 10 centimos
			P1=0xFF;							//Reset dos pinos de sele��o de moedas e bebidas
			mydelay(20000);
			break;	
				
		case 11:								//0000 1011 
			valor = valor + 20;		//Introduzida moeda 20 centimos, somamos 20
			stock20++;						//Adiciona uma moeda ao stock de 20 centimos
			P1=0xFF;							//Reset dos pinos de sele��o de moedas e bebidas
			mydelay(20000);
			break;
		
		case 7:									//0000 0111 
			valor = valor + 50;		//Introduzida moeda 50 centimos, somamos 50
			stock50++;						//Adiciona uma moeda ao stock de 50 centimos
			P1=0xFF;							//Reset dos pinos de sele��o de moedas e bebidas
			mydelay(20000);
			break;
	}
	
	total = valor;
	
}

void ler_bebida(void)
{
		
	int y = 0;
	y = (P1&0xF0);	//introdu�ao de uma mascara, executa uma opera�ao AND bit a bit, passando para 0 os valores dos pinos referentes �s moedas
									//desta forma sao apenas lidos os pinos referentes �s bebidas
	bebida = 0;
	custo = 0;
	
	switch(y)				//Y contem valores dos pinos referentes �s bebidas (os das moedas estao a 0), salta para um caso mediante a combina��o de bits
	{								//cada combina��o de bits equivale � sele��o de uma das bebidas, esta combina��o est� em decimal
		
		case 240:								//1111 0000 
			bebida = 0;						//N�o foi selecionada nenhuma bebida
			custo = 0;						//Custo � zero		
			P1=0xFF;							//Reset dos pinos de sele��o de moedas e bebidas
			break;
			
		case 224:								//1110 0000
			if(stockb1 > 0)				//caso exista a bebida1 em stock
			{
				bebida = 1;					//Selecionada bebida1
				custo = custob1;		//Custo da bebida escolhida passa a ter o valor do custo da bebida1
			}
			P1=0xFF;							//Reset dos pinos de sele��o de moedas e bebidas
			mydelay(20000);
			break;
		
		case 208:								//1101 0000
			if(stockb2 > 0)				//caso exista a bebida2 em stock
			{
				bebida = 2;					//Selecionada bebida2
				custo = custob2;		//Custo da bebida escolhida passa a ter o valor do custo da bebida2		
			}
			P1=0xFF;							//Reset dos pinos de sele��o de moedas e bebidas
			mydelay(20000);
			break;	
				
		case 176:								//1011 0000
			if(stockb3 > 0)				//caso exista a bebida3 em stock
			{
				bebida = 3;					//Selecionada bebida3
				custo = custob3;		//Custo da bebida escolhida passa a ter o valor do custo da bebida3			
			}
			P1=0xFF;							//Reset dos pinos de sele��o de moedas e bebidas
			mydelay(20000);
			break;
		
		case 112:								//0111 0000
			if(stockb4 > 0)				//caso exista a bebida4 em stock
			{		
				bebida = 4;					//Selecionada bebida4
				custo = custob4;		//Custo da bebida escolhida passa a ter o valor do custo da bebida4	
			}
			P1=0xFF;							//Reset dos pinos de sele��o de moedas e bebidas
			mydelay(20000);
			break;
	}
		
}

void checkTotalCusto(unsigned int total, unsigned int custo)
{
	if(total >= custo && bebida != 0 && estado != 3) //verifica se o dinheiro inserido � maior ou igual ao custo da bebida selecionada e se existe alguma bebida selecionada
	{																								 //Estado nao pode ser igual a 3 porque significa que o bot�o cancel foi pressionado e as proximas fun�oes a executar sao as do estado 3
		
		estado = 2;				//muda para o estado 2 para serem executadas as fun�oes desse mesmo estado (estado de venda)
	}	
}

void mydelay(unsigned int delay) //fun��o que gera um atraso
{
	unsigned int i;
	for (i=0; i<delay; i++);			//a fun��o acaba quando "contar" de 0 at� ao valor do delay
}

unsigned int calcularTroco(unsigned int total, unsigned int custo)
{
	int troco = 0;
	troco = total - custo; //troco a dar � o valor do total de dinheiro inserido menos o valor do custo da bebida selecionada
	
	return troco;					//retorna valor do troco a dar
}

void devolverTroco(unsigned int troco)
{
		if(troco == 0)	//caso o troco seja 0 (n�o � preciso dar troco)
		{
			return;				//sai da fun��o
		}
		else		
		{
			while(stock50 > 0 && troco >= 50)		//verifica se existe stock de moedas de 0,50 e se troco a dar � igual ou maior a 50 cents
			{
				mydelay(20000);
				rodarMotor50();										//roda o motor das moedas de 0,50 euros, devolvendo uma moeda
				mydelay(20000);
				
				stock50--;												//decrementa stock das moedas de 0,50 euros
				troco = troco - 50;								//decrementa o valor da moeda de 0,50 euros ao troco a dar
				TXD_data(troco);
			}
			
			while(stock10 > 0 && troco >= 10)		//verifica se existe stock de moedas de 0,10 e se troco a dar � igual ou maior a 10 cents
			{
				mydelay(20000);
				rodarMotor10();										//roda o motor das moedas de 0,10 euros, devolvendo uma moeda
				mydelay(20000);
				
				stock10--;												//decrementa stock das moedas de 0,10 euros
				troco = troco - 10;								//decrementa o valor da moeda de 0,10 euros ao troco a dar
				TXD_data(troco);				
			}
			
			while(stock05 > 0 && troco >= 5)		//verifica se existe stock de moedas de 0,05 e se troco a dar � igual ou maior a 05 cents
			{
				mydelay(20000);
				rodarMotor05();										//roda o motor das moedas de 0,05 euros, devolvendo uma moeda
				mydelay(20000);
				
				stock05--;												//decrementa stock das moedas de 0,05 euros
				troco = troco - 5;								//decrementa o valor da moeda de 0,05 euros ao troco a dar
				TXD_data(troco);				
			}			
		}
		
		//se n�o for possivel continuar a dar troco devido � falta de stock de moedas a fun��o termina (mesmo que o valor do troco a dar n�o chegue a 0)
		//desta forma o utilizador n�o vai receber todo o troco que tem direito mas vai receber a bebida escolhida
}

void darBebida(unsigned int bebida)
{
	switch(bebida)		//mediante o valor da variavel bebida, executa um dos casos. Cada caso corresponde a uma das quatro bebidas
	{
		case 1:							//foi escolhida a bebida1
			
			rodarMotorB1();		//roda o motor da bebida1, devolvendo a bebida1
			stockb1--;				//decrementa o stock da bebida1
			break;
		
		case 2:							//foi escolhida a bebida2
			
			rodarMotorB2();		//roda o motor da bebida2, devolvendo a bebida2
			stockb2--;				//decrementa o stock da bebida2
			break;
		
		case 3:							//foi escolhida a bebida3
			
			rodarMotorB3();		//roda o motor da bebida3, devolvendo a bebida3
			stockb3--;				//decrementa o stock da bebida3
			break;
		
		case 4:							//foi escolhida a bebida4
			
			rodarMotorB4();		//roda o motor da bebida4, devolvendo a bebida4
			stockb4--;				//decrementa o stock da bebida4
			break;
	}

}

void inicializarStocks(void)
{
	stock05 = 150;		//valores dos stocks das moedas
	stock10 = 150;
	stock20 = 150;
	stock50 = 150;

	stockb1 = 25;		//valores dos stocks das bebidas
	stockb2 = 25;
	stockb3 = 25;
	stockb4 = 25;
}

void inicalizarPortas(void)
{
	
	P1 = 0xFF; 			//incializa��o dos botoes das moedas e e bebidas - l�gica negada
	
	cancel = 1;			//inicializa��o do pino do bot�o Cancel - l�gica negada
		
	sensor10 = 1;		//inicializa��o dos sensores dos motores das moedas - l�gica negada
	sensor50 = 1;
	sensor05 = 1;

	motor10 = 0;		//inicializa��o dos motores das moedas - l�gica normal
	motor50 = 0;
	motor05 = 0;

	sensorb1 = 1;		//inicializa��o dos sensores dos motores das bebidas - l�gica negada
	sensorb2 = 1;
	sensorb3 = 1;
	sensorb4 = 1;

	motorb1 = 0;		//inicializa��o dos motores das bebidas - l�gica normal
	motorb2 = 0;
	motorb3 = 0;
	motorb4 = 0;

}

void activarTransPortaSerial(void)
{
	SCON = 0x50;     //Porta serial a funcionar em modo 1 (8-bit UART) (0101 0000b ou 80d) SFR SCON - SM0 = 0, SM1 = 1 , REN = 1
	TMOD = 0x20;     //utilizar o Timer 1 no modo 2 (0001 0000b ou 32d) SFR TMOD - C/T = 0(usar como timer), M1 = 1, M0 = 0 (do lado so timer1, 4 bits mais significativos do SFR TMOD)
	TH1 = 0xFD;      //9600 Bps  at 11.059MHz (taxa de transmiss�o)
	TL1 = 0xFD;      //timer de 8 bits
	TR1 = 1;         //"liga" o timer1 - TR1 est� no SFR TCON
	TI = 1;          //inicializa��o da flag de emiss�o
}

void interrupcoes_init(void)
{
	IP 	= 1; 		//interrup��o externa 0 tem a prioridade mais elevada (0000 0001b ou 0x01), SFR IP - PX0 = 1
	IE 	= 129; 	//ativa interrup�ao externa 0 (1000 0001b ou 0x81), SFR IE - EA = 1 (habilita o uso de interrup��es) , EX0 = 1 (habilita o uso da interrup��o externa0)
	IT0 = 1;		//a interrup��o externa 0 vai ser detetada na transi��o descendente (1 para 0) IT0 � um bit do SFR TCON
}

void TXD_data(unsigned char value)
{
	
	while (TI!=1){};     //Enquanto T1 n�o for 1 n�o executa as proximas instru�oes (emiss�o pr�via ainda a decorrer)
	TI=0;                //Limpa a flag de emiss�o (TI) para a proxima emiss�o (tem de ser feito por software)
	SBUF = value;        //coloca value no buffer (SFR SBUF)
	
}

void external_int0(void) interrupt 0	//fun��o de tratamento da interrup��o externa 0, fun��o � executada quando o bot�o cancelar � pressionado
{
	
	if(estado == 1) //s� faz sentido	 cancelar quando estamos no estado de introdu�ao de moedas/sele�ao bebida
	{
		estado = 3; 	//Muda para estado 3
	}
	P1 = 0xFF; 			//Reset dos pinos de sele��o de moedas e bebidas
	cancel = 1;			//Reset do pino do bot�o cancel
	
}

void rodarMotor50(void)
{
				while(sensor50 == 1)	//enquanto o sensor do motor das moedas de 0,50 euros n�o for activado
				{
					motor50 = 1;				//roda o motor das moedas de 0,50 euros
				}
	
				//roda o motor um pouco para este deixar de activar o sensor
				while(sensor50 == 0)	//enquanto o sensor do motor das moedas de 0,50 euros est� activado
				{
					motor50 = 1;				//roda o motor das moedas de 0,50 euros
				}	
				motor50 = 0;					//para o motor das moedas de 0,50 euros
}

void rodarMotor10(void)
{
				while(sensor10 == 1)	//enquanto o sensor do motor das moedas de 0,10 euros n�o for activado
				{
					motor10 = 1;				//roda o motor das moedas de 0,10 euros
				}
				
				//roda o motor um pouco para este deixar de activar o sensor
				while(sensor10 == 0)	//enquanto o sensor do motor das moedas de 0,10 euros est� activado
				{
					motor10 = 1;				//roda o motor das moedas de 0,10 euros
				}	
				motor10 = 0;					//para o motor das moedas de 0,10 euros
}

void rodarMotor05(void)
{
				while(sensor05 == 1)	//enquanto o sensor do motor das moedas de 0,05 euros n�o for activado
				{
					motor05 = 1;				//roda o motor das moedas de 0,05 euros
				}
				
				//roda o motor um pouco para este deixar de activar o sensor
				while(sensor05 == 0)	//enquanto o sensor do motor das moedas de 0,05 euros est� activado
				{
					motor05 = 1;				//roda o motor das moedas de 0,05 euros
				}	
				motor05 = 0;					//para o motor das moedas de 0,05 euros
}

void rodarMotorB1(void)
{
			while(sensorb1 == 1)	//enquanto o sensor do motor da bebida1 n�o for activado
			{
				motorb1 = 1;				//roda o motor da bebida1
			}
			
			//roda o motor um pouco para este deixar de activar o sensor
			while(sensorb1 == 0)	//enquanto o sensor do motor da bebida1 est� activado
			{
				motorb1 = 1;				//roda o motor da bebida1
			}	
			motorb1 = 0;					//para o motor da bebida1
}


void rodarMotorB2(void)
{
			while(sensorb2 == 1)	//enquanto o sensor do motor da bebida2 n�o for activado
			{
				motorb2 = 1;				//roda o motor da bebida2
			}
			
			//roda o motor um pouco para este deixar de activar o sensor
			while(sensorb2 == 0)	//enquanto o sensor do motor da bebida2 est� activado
			{
				motorb2 = 1;				//roda o motor da bebida2
			}	
			motorb2 = 0;					//para o motor da bebida2
}

void rodarMotorB3(void)
{
			while(sensorb3 == 1)	//enquanto o sensor do motor da bebida3 n�o for activado
			{
				motorb3 = 1;				//roda o motor da bebida3
			}
			
			//roda o motor um pouco para este deixar de activar o sensor
			while(sensorb3 == 0) 	//enquanto o sensor do motor da bebida3 est� activado
			{
				motorb3 = 1;				//roda o motor da bebida3
			}	
			motorb3 = 0;					//para o motor da bebida3
}

void rodarMotorB4(void)
{
			while(sensorb4 == 1)	//enquanto o sensor do motor da bebida4 n�o for activado
			{
				motorb4 = 1;				//roda o motor da bebida4
			}
			
			//roda o motor um pouco para este deixar de activar o sensor
			while(sensorb4 == 0) 	//enquanto o sensor do motor da bebida4 est� activado
			{
				motorb4 = 1;				//roda o motor da bebida4
			}	
			motorb4 = 0;					//para o motor da bebida4
}

void calibrarMotores(void)
{
	//chama as fun�oes que rodam os motores, deixando-os calibrados na posi��o imediatamente � "frente" do respectivo sensor

	rodarMotor50();
	rodarMotor10();
	rodarMotor05();
	rodarMotorB1();
	rodarMotorB2();
	rodarMotorB3();
	rodarMotorB4();
}

//void rodarMotor(sbit motor, sbit sensor)
//{
//	while(sensor == 1) //enquanto o sensor for 1, roda o motor
//	{
//		motor = 1;
//	}
//	
//	while(sensor == 0) //roda o motor um pouco, para este deixar de activar o sensor
//	{
//		motor = 1;
//	}
//	
//	motor = 0;		//para o motor
//}

