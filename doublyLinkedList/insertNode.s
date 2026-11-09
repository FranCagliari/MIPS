#include <iregdef.h>

//int InsertNode(struct DoubledLinkedList *list, struct Node *newNode)
//a0 *list, a1 *node

	.text
	.globl InsertNode
	.ent InsertNode
	
InsertNode:
	//t0 = aux	
	sw zero, 4(a1) //newNode->prev = NULL;
    sw zero, 8(a1) //newNode->next = NULL;
    
    lw t0, 0(a0)   //if(list->size == 0)
    beq t0, zero, listaVazia //insere como primeiro
    
    //else procura o lugar certo
    
    lw t0, 4(a0)   //aux = list->head;
    
while: //encontrar posicao correta	
	beq t0, zero, tipoInsercao
	
if:

	lw t1, 0(a1)  //t1 = newNode->student 
	lw t1, 92(t1) //t1 = newNode->student->registration
	
	lw t2, 0(t0)  //t2 = aux->student
	lw t2, 92(t2) //t2 = aux->student->registration
	
	slt t9, t2, t1		//compara aux->registr > newNode->registr
	beq t9, zero, found //se t9 = 0, aux->registr =< newNode->registr
	
	//else
	
	lw t0, 8(t0)  //aux = aux->next
	j while
	
found:
	beq t2, t1, jaInserido	//se registr iguais, ja foi inserido
	//se n ja inserido, segue o fluxo pra tipoInsercao
	
tipoInsercao:	//verificar tipo de insercao		
	lw t3, 4(a0)		//t3 = list->head
	beq t0, t3, caso1 	//aux == list->head	
	beq t0, zero, caso2 //aux == NULL
	
	//caso3            
    lw t3, 4(t0)    //t3 = aux->prev
    sw a1, 8(t3)	//prev->next = newNode
    
    sw t3, 4(a1)	//newNode->prev = aux->prev
    sw a1, 4(t0)	//aux->prev = newNode;
    sw t0, 8(a1)	//newNode->next = aux;
	
	j insertOK
    
caso1:
	sw a1, 4(t0)  	//aux->prev = newNode;
	sw t0, 8(a1)	//newNode->next = aux;
	sw a1, 4(a0)	//list->head = newNode;
	j insertOK

caso2:  
  	lw t3, 8(a0)	//t3 = list->tail
  	sw t3, 4(a1)	//newNode->prev = list->tail
	
	sw a1, 8(t3)	//list->tail->next = newNode
	sw a1, 8(a0)	//list->tail = newNode
	j insertOK

listaVazia:
	sw a1, 4(a0)   //list->head = newNode;
	sw a1, 8(a0)   //list->tail = newNode;
	
	sw zero, 0(a0)
	j insertOK
//	addi t0, t0, 1 //list->size++;
//	sw t0, 0(a0)
//	j fim	
	
insertOK:
	lw t0, 0(a0)		//t0 = list->size
	addi t0, t0, 1 	//t0++
	sw t0, 0(a0)		//list->size++ (list->size = t0)

	addi v0, zero, 0 //return INSERTION_OK (0)
	j fim
	
jaInserido:
	addi v0, zero, -1 //return STUDENT_ALREADY_INSERTED;
	
fim:
	jr ra
	nop
	.end InsertNode