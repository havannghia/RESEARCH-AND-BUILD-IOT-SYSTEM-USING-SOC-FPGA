#ifndef _UART_
#define _UART_

#define UART_OFFSET_DATA        0x0
#define UART_OFFSET_CONTROL     0x1

void UART_Write (void *uart, int offset, int value){
    *((int*)uart + offset) = value;
}

int UART_Read (void *uart, int offset){
    int data = *((int*)uart + offset);
    return data;
}
void UART_Put_Char (void *uart, char c){
    int control;
    control = UART_Read(uart, UART_OFFSET_CONTROL);
   if( control & 0xFF0000){
        UART_Write(uart, UART_OFFSET_DATA, c);
   }
}
char UART_Get_Char (void *uart, char *number){
    int data;
    data = UART_Read(uart, UART_OFFSET_DATA);
    *number = (data & 0xFF0000) >> 16;  
    if(data & 0x00008000){
        return ((char) data & 0xFF);
    }else{
       return ('\0');
    }
}

void UART_Put_Buffer(char *buffer, char *pointer, char value){
    buffer[*pointer] = value;
    *pointer = *pointer + 1;
}

char UART_Get_Buffer(char  buffer[], char *pointer){
    char c = buffer[*pointer];
    *pointer = *pointer - 1;
    return c;
}

void UART_Show_Buffer(char buffer[], char pointer){
    int i = 0;
    printf("Char = ");
    for(i = 0; i <= pointer; i++){
        printf("%c",buffer[i]);
    }
    printf("\n");
}
#endif 