#ifndef _REGISTERMM_H_
#define _REGISTERMM_H_

#define TFR_CMD (0x0)
#define RX_DATA (0x1)
#define CTRL    (0x2)
#define ISER    (0x3)
#define ISR     (0x4)
#define STATUS  (0x5)
#define TFR_CMD_FIFO_LVL    (0x6)
#define RX_DATA_FIFO_LVL    (0x7)
#define SCL_LOW             (0x8)
#define SCL_HIGH            (0x9)
#define SDA_HOLD            (0xA)

typedef struct {
    int id;
    float value;
    char name[20];
} DataItem;
void init(void* i2c);

void i2c_writedata(void* i2c,unsigned char data,unsigned int stop);
void i2c_write(void* i2c,unsigned char add,unsigned char data);
unsigned int i2c_read(void* i2c,unsigned char add);
unsigned int i2c_readdata(void* i2c, unsigned int stop);


#endif
