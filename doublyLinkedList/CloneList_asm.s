#include <iregdef.h>

#define SIZEOF_LIST       12    
#define SIZEOF_NODE       12    
#define SIZEOF_STUDENT    148   


#define FRAME_SIZE        40

//Constantes
	.text
	.globl CloneList_asm
	.ent CloneList_asm

CloneList_asm:
	.frame sp, FRAME_SIZE, ra
	.mask 0x800F0000, -4        // ra e s0-s3 salvos na pilha


	addiu sp, sp, -FRAME_SIZE   // aloca o frame na pilha
	sw ra, 36(sp)               // salva endereco de retorno
	sw s3, 32(sp)               // salva os registradores s que serao usados
	sw s2, 28(sp)
	sw s1, 24(sp)
	sw s0, 20(sp)

	move s0, a0                 // s0 = list (a0 usado nas chamadas)

	// lista clonada
	li a0, SIZEOF_LIST
	jal malloc
	move s1, v0                 // s1 = clonedList

	// CriarLista
	move a0, s1
	jal CreateList


	lw s2, 4(s0)                // s2 = list->head

cloneWhile:                     // while (aux != NULL) {
	beq s2, zero, cloneEnd

	li a0, SIZEOF_NODE
	jal malloc
	move s3, v0                 // s3 = node
	li a0, SIZEOF_STUDENT
	jal malloc
	sw v0, 0(s3)                // node->student = v0

	//Copia o nome do estudante
	lw a0, 0(s3)                // a0 = node->student->name
	lw a1, 0(s2)                // a1 = aux->student->name
	jal strcpy

	// Copia o registro
	// (t0/t1 podem ser usados aqui pois nao ha chamada no meio)
	lw t0, 0(s2)                // t0 = aux->student
	lw t0, 92(t0)               // t0 = aux->student->registration
	lw t1, 0(s3)                // t1 = node->student
	sw t0, 92(t1)               // node->student->registration = t0

	// Copia o curso
	lw a0, 0(s3)                // a0 = node->student
	addiu a0, a0, 96            // a0 = node->student->course
	lw a1, 0(s2)                // a1 = aux->student
	addiu a1, a1, 96            // a1 = aux->student->course
	jal strcpy

	// insere o no clonado na lista
	move a0, s1                 // a0 = clonedList
	move a1, s3                 // a1 = node
	jal InsertNode_asm

	// aux = aux->next;    //aponta para o próximo no
	lw s2, 8(s2)
	j cloneWhile                // }

cloneEnd:
	// retorna ListaClonada
	move v0, s1

	lw s0, 20(sp)               // restaura os registradores salvos
	lw s1, 24(sp)
	lw s2, 28(sp)
	lw s3, 32(sp)
	lw ra, 36(sp)
	addiu sp, sp, FRAME_SIZE    // libera o frame
	jr ra

	.end CloneList_asm
