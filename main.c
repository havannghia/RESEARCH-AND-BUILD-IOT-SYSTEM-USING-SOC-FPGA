#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"
#include <pthread.h>
#include "registerUart.h"

#include "registerMM.h"

#define HW_REGS_BASE (ALT_STM_OFST)
#define HW_REGS_SPAN (0x04000000)
#define HW_REGS_MASK (HW_REGS_SPAN - 1)

void initUART(void *uart)
{
    // Set the baud rate (assuming a fixed baud rate)
    // Adjust the value according to your desired baud rate
    int baudrate = 115200;
    int d = (50000000 / (baudrate)) - 1;
    *(unsigned int *)(uart + divisor * 4) = d;
}
void checkRegister(void *uart)
{
    // printf("RX = %x	,", *(unsigned int *)(uart + rxdata * 4));
    printf("TX = %x	\n", *(unsigned int *)(uart + txdata * 4));
    printf("Status = %x	\n", *(unsigned int *)(uart + status * 4));
    printf("Exception = %x	,", (*(unsigned int *)(uart + status * 4)) & 0x100);
    printf("ROE = %x	,", (*(unsigned int *)(uart + status * 4)) & 0x8);
    printf("TOE = %x	,", (*(unsigned int *)(uart + status * 4)) & 0x10);
    printf("Break = %x	,", (*(unsigned int *)(uart + status * 4)) & 0x4);
    printf("Frame error = %x	\n", (*(unsigned int *)(uart + status * 4)) & 0x2);
}
void resetStatus(void *uart)
{
    *(unsigned int *)(uart + status * 4) = 0;
}
bool checkTx(void *uart)
{
    unsigned int check = ((*(unsigned int *)(uart + status * 4)) & 0x40);
    return check;
}
void sendChar(void *uart, char Character)
{
    while (checkTx(uart) == 0)
    {
    }
    *(unsigned int *)(uart + txdata * 4) = Character;
}
void sendString(void *uart, char *str, int num)
{
    int i;
    for (i = 0; i < num; i++)
    {
        sendChar(uart, *str);
        str++;
    }
}
bool checkRx(void *uart)
{
    unsigned int check = ((*(unsigned int *)(uart + status * 4)) & 0x80);
    return check;
}
unsigned char receiveChar(void *uart)
{
    while (checkRx(uart) == 0)
    {
    }
    return *(unsigned int *)(uart + rxdata * 4);
}

void init(void *i2c);
void i2c_writedata(void *i2c, unsigned char data, unsigned int stop);
void i2c_write(void *i2c, unsigned char add, unsigned char data);
unsigned int i2c_read(void *i2c, unsigned char add);
unsigned int i2c_readdata(void *i2c, unsigned int stop);

void writeDataToFile(const char *filename, DataItem *data, int numItems);
void readDataFromFile(const char *filename, DataItem *data, int numItems);

void get_RH_and_temperature(void *i2c, unsigned int add, float *Temp, float *humidity);

void writeDataToFile(const char *filename, DataItem *data, int numItems)
{
    FILE *file = fopen(filename, "wb");
    if (file == NULL)
    {
        printf("Failed to open the file for writing.\n");
        return;
    }

    fwrite(data, sizeof(DataItem), numItems, file);
    fclose(file);

    printf("Data successfully written to file.\n");
}

void readDataFromFile(const char *filename, DataItem *data, int numItems)
{
    FILE *file = fopen(filename, "rb");
    if (file == NULL)
    {
        printf("Failed to open the file for reading.\n");
        return;
    }

    fread(data, sizeof(DataItem), numItems, file);
    fclose(file);

    printf("Data successfully read from file.\n");
}
typedef struct
{
    void *uart;
    void *led;
} ThreadArgs;
void *threadFunc(void *arg)
{
    // get uart and led from struct and change void* arg -> ThreadArgs
    ThreadArgs *threadArgs = (ThreadArgs *)arg;
    // check RRDY in status register uart
    unsigned int checkRx = ((*(unsigned int *)((threadArgs->uart) + status * 4)) & 0x80);
    unsigned char rx_data;

    while (checkRx == 0)
    {
    }
    printf("========================================================\n");
    rx_data = (*(unsigned int *)((threadArgs->uart) + rxdata * 4) & 0xf);
    printf("receive uart: %x\n", rx_data);
    printf("========================================================\n");
    switch (rx_data)
    {
    case 0x1:
        if ((*(uint32_t *)(threadArgs->led)) == 0xf0)
        {
            *(uint32_t *)(threadArgs->led) = 0xff;
        }
        else if (*(uint32_t *)(threadArgs->led) == 0xff)
        {
            *(uint32_t *)(threadArgs->led) = 0xff;
        }
        else
        {
            *(uint32_t *)(threadArgs->led) = 0xf;
        }

        break;
    case 0x3:
        if (*(uint32_t *)(threadArgs->led) == 0x0f)
        {
            *(uint32_t *)(threadArgs->led) = 0xff;
        }
        else if (*(uint32_t *)(threadArgs->led) == 0xff)
        {
            *(uint32_t *)(threadArgs->led) = 0xff;
        }
        else
        {
            *(uint32_t *)(threadArgs->led) = 0xf0;
        }

        break;
    case 0x2:
        if (*(uint32_t *)(threadArgs->led) == 0xff)
        {
            *(uint32_t *)(threadArgs->led) = 0x0f;
        }
        else if (*(uint32_t *)(threadArgs->led) == 0x0f)
        {
            *(uint32_t *)(threadArgs->led) = 0x0f;
        }
        else
        {
            *(uint32_t *)(threadArgs->led) = 0;
        }
        break;
    case 0:
        if (*(uint32_t *)(threadArgs->led) == 0xff)
        {
            *(uint32_t *)(threadArgs->led) = 0xf0;
        }
        else if (*(uint32_t *)(threadArgs->led) == 0xf0)
        {
             *(uint32_t *)(threadArgs->led) = 0xf0;
        }
        else
        {
            *(uint32_t *)(threadArgs->led) = 0;
        }
        break;

    default:
        *(uint32_t *)(threadArgs->led) = 0;
        break;
    }

    pthread_exit(NULL);
}
int main()
{

    void *virtual_base;
    int fd;
    void *i2c;
    void *led;
    void *sw_addr;
    void *uart;
    int ret = 0;
    ThreadArgs args;
    // map the address space for the LED registers into user space so we can interact with them.
    // we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

    if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
    {
        printf("ERROR: could not open \"/dev/mem\"...\n");
        return (1);
    }

    virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);

    if (virtual_base == MAP_FAILED)
    {
        printf("ERROR: mmap() failed...\n");
        close(fd);
        return (1);
    }

    uart = virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + UART_0_BASE) & (unsigned long)(HW_REGS_MASK));
    i2c = virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + I2C_0_BASE) & (unsigned long)(HW_REGS_MASK));
    sw_addr = virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + DIPSW_PIO_BASE) & (unsigned long)(HW_REGS_MASK));
    led = virtual_base + ((unsigned long)(ALT_LWFPGASLVS_OFST + LED_PIO_BASE) & (unsigned long)(HW_REGS_MASK));
    args.uart = uart;
    args.led = led;
    int num = 0;
    pthread_t tid;
    int i = 0;
    int numItems = 4;

    while (1)
    {
        // tem = *(uint32_t *)sw_addr;
        // switch (tem)
        // {
        // case 0x1:
        //      if ((*(uint32_t *)led == 0xf0))
        //     {
        //         *(uint32_t *)led = 0xff;
        //     }
        //     else if ((*(uint32_t *)led) == 0xff)
        //     {
        //         *(uint32_t *)led = 0xff;
        //     }
        //     else
        //     {
        //         *(uint32_t *)led = 0xf;
        //     }
        // case 0x3:
        //     *(uint32_t *)led = ledOn;
        //     break;
        // case 0x2:
        //     *(uint32_t *)led = led2On;
        // case 0:
        //     *(uint32_t *)led = ledOff;

        // default:
        //     break;
        // }

        int led1 = ((*(uint32_t *)led) & 1);
        int led2 = ((*(uint32_t *)led) & 0x10) >> 4;
        float Temp;
        float humidity;
        unsigned int add = 0x44;

        init(i2c);
        printf("START \n");
        printf("Interrupt Status Register = %.5x\n", *(unsigned int *)(i2c + ISR * 4));

        get_RH_and_temperature(i2c, add, &Temp, &humidity);
        printf("\n");
        printf("Relative Humidity= %.2f %RH \n", humidity);
        printf("temperature = %.2f C \n", Temp);
        DataItem data[] = {
            {1, Temp, "temperature"},
            {2, humidity, "humidity"},
            {3, led1, "led1"},
            {4, led2, "led2"}};

        data[0].value = Temp;
        data[1].value = humidity;
        data[2].value = led1;
        data[3].value = led2;
        writeDataToFile("data.bin", data, numItems);

        // Clear the data array
        memset(data, 0, sizeof(data));

        readDataFromFile("data.bin", data, numItems);

        // Display the read data
        for (i = 0; i < numItems; i++)
        {
            printf("ID: %d, Value: %.2f, Name: %s\n", data[i].id, data[i].value, data[i].name);
        }

        printf("status = 0x%x\n", (*(unsigned int *)(i2c + STATUS * 4)));
        printf("Interrupt Status Register = %.5x\n", *(unsigned int *)(i2c + ISR * 4));

        usleep(1000 * 1000);
        // disable i2c
        *(unsigned int *)(i2c + CTRL * 4) = 0x0;

        initUART(uart);
        resetStatus(uart);

        ret = pthread_create(&tid, NULL, threadFunc, (void *)&args);
        if (ret != 0)
        {
            printf("Thread created error\n");
        }
    }
    // clean up our memory mapping and exit

    if (munmap(virtual_base, HW_REGS_SPAN) != 0)
    {
        printf("ERROR: munmap() failed...\n");
        close(fd);
        return (1);
    }

    close(fd);

    return (0);
}

void init(void *i2c)
{
    // init(ptr);
    *(unsigned int *)(i2c + CTRL * 4) = 0x0; // disable avalon i2c
    printf("status = 0x%x\n", (*(unsigned int *)(i2c + STATUS * 4)));
    *(unsigned int *)(i2c + ISER * 4) = 0x0; // config interup enable
    // config SCL_LOW for 100 KHz, spec require scl tlow min = 4,7 us |-> F = 50 MHz, config value >=  235
    *(unsigned int *)(i2c + SCL_LOW * 4) = 235;
    // config SCL_HIGH for 100 KHz, spec require scl thigh min = 4,0 us |-> F = 50 MHz, config value >=  200
    *(unsigned int *)(i2c + SCL_HIGH * 4) = 200;
    // config SDA_HOLD for 100 KHz, spec require scl thigh min = 5,0 us |-> F = 50 MHz, config value >=  250
    *(unsigned int *)(i2c + SDA_HOLD * 4) = 200; //
    *(unsigned int *)(i2c + CTRL * 4) = 0x29;    // RX_DATA_FIFO_THD =1/2 fifo |TFR_CMD_FIFO_THD = 1/2 fifo| BUS_SPEED =100kb  |enable avalon i2c
}

void i2c_write(void *i2c, unsigned char add, unsigned char data)
{

    while (!((*(unsigned int *)(i2c + ISR * 4)) & 0x1))
    { // check TX_READ
        printf("TX not ready \n");
    }
    *(unsigned int *)(i2c + TFR_CMD * 4) = 0x2fe & ((add << 1) | 0xf00); // 0x2 << 8 | (0x55 << 1) | 0x0; // add = 0x55, write mode, gen start
    *(unsigned int *)(i2c + TFR_CMD * 4) = 0x1ff & ((data) | 0xf00);     // add = data, write mode,  gen stop
    printf("i2c write done\n");

    printf("status = 0x%x\n", (*(unsigned int *)(i2c + STATUS * 4)));
}

void i2c_writedata(void *i2c, unsigned char data, unsigned int stop)
{
    unsigned int NACK_DET;
    NACK_DET = *(unsigned int *)(i2c + ISR * 4);
    NACK_DET = (NACK_DET & 0x04) >> 2;
    while (!((*(unsigned int *)(i2c + ISR * 4)) & 0x1))
    { // check TX_READ
        printf("TX non ready\n");
    }
    *(unsigned int *)(i2c + TFR_CMD * 4) = data | stop; // write data
    printf("write data done\n");
    printf("Interrupt Status Register = %.5x\n", *(unsigned int *)(i2c + ISR * 4));
    printf("status = 0x%x\n", (*(unsigned int *)(i2c + STATUS * 4)));
}
void i2c_writeadd(void *i2c, unsigned char add)
{
    unsigned int NACK_DET;
    NACK_DET = *(unsigned int *)(i2c + ISR * 4);
    NACK_DET = (NACK_DET & 0x04) >> 2;
    while (!((*(unsigned int *)(i2c + ISR * 4)) & 0x1))
    { // check TX_READ
        printf("TX non ready\n");
    }
    *(unsigned int *)(i2c + TFR_CMD * 4) = 0x2fe & ((add << 1) | 0xf00); // add = 0x55, write mode, gen start
    printf("write add done\n");
    printf("Interrupt Status Register = %.5x\n", *(unsigned int *)(i2c + ISR * 4));
    printf("status = 0x%x\n", (*(unsigned int *)(i2c + STATUS * 4)));
}
void i2c_read_add(void *i2c, unsigned char add)
{
    unsigned int NACK_DET;
    NACK_DET = *(unsigned int *)(i2c + ISR * 4);
    NACK_DET = (NACK_DET & 0x04) >> 2;
    while (!((*(unsigned int *)(i2c + ISR * 4)) & 0x1))
    { // check TX_READ
        printf("TX non ready\n");
    }

    *(unsigned int *)(i2c + TFR_CMD * 4) = (0x2ff & ((add << 1) | 0xf01)); // add = 0x55, read mode, gen start
    printf("read add done\n");
    printf("Interrupt Status Register = %.5x\n", *(unsigned int *)(i2c + ISR * 4));
}
unsigned int i2c_read(void *i2c, unsigned char add)
{

    while (!((*(unsigned int *)(i2c + ISR * 4)) & 0x1))
    { // check TX_READ
        printf("TX non ready\n");
    }
    *(unsigned int *)(i2c + TFR_CMD * 4) = (0x2ff & ((add << 1) | 0xf01)); // add = 0x55, read mode, gen start
    *(unsigned int *)(i2c + TFR_CMD * 4) = 0x100;                          // read mode gen stop

    printf("status = 0x%x\n", (*(unsigned int *)(i2c + STATUS * 4)));
    // while (!((*(unsigned int*)(i2c + ISR*4)) & 0x2)) // check TX_READ is one?
    //  {
    //     printf("RX non ready\n");
    //  }
    printf("Read done \n");
    return *(unsigned int *)(i2c + RX_DATA * 4);
}
unsigned int i2c_readdata(void *i2c, unsigned int stop)
{
    unsigned int NACK_DET;
    NACK_DET = *(unsigned int *)(i2c + ISR * 4);
    NACK_DET = (NACK_DET & 0x04) >> 2;
    while (!((*(unsigned int *)(i2c + ISR * 4)) & 0x1))
    { // check TX_READ
        printf("TX non ready\n");
    }
    *(unsigned int *)(i2c + TFR_CMD * 4) = stop; // add, write don't care, start=0, stop or nostop

    printf("status = 0x%x\n", (*(unsigned int *)(i2c + STATUS * 4)));
    printf("Read done \n");
    printf("Interrupt Status Register = %.5x\n", *(unsigned int *)(i2c + ISR * 4));
    return *(unsigned int *)(i2c + RX_DATA * 4);
}

void get_RH_and_temperature(void *i2c, unsigned int add, float *Temp, float *humidity)
{

    unsigned int data[6];
    i2c_writeadd(i2c, add); // write add sensor
                            //  Send measurement command
    i2c_writedata(i2c, 0x2C, 0);
    i2c_writedata(i2c, 0x06, 0x100); // stop
    usleep(1000);

    i2c_read_add(i2c, 0x44); // read add
    data[0] = i2c_readdata(i2c, 0);
    data[1] = i2c_readdata(i2c, 0);
    data[2] = i2c_readdata(i2c, 0);
    data[3] = i2c_readdata(i2c, 0);
    data[4] = i2c_readdata(i2c, 0);
    data[5] = i2c_readdata(i2c, 0x100); // stop
    *Temp = ((((data[0] * 256.0) + data[1]) * 175) / 65535.0) - 45;

    *humidity = ((((data[3] * 256.0) + data[4]) * 100) / 65535.0);
}
