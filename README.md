# RESEARCH-AND-BUILD-IOT-SYSTEM-USING-SOC-FPGA
This thesis primarily focuses on researching and constructing an IoT system utilizing a combination of SoC (System on Chip) and FPGA (Field Programmable Gate Array) technologies, along with utilizing Azure IoT Central as the underlying database
![System overview](https://user-images.githubusercontent.com/130819168/266976715-8651736f-fe53-4ebc-aa5d-efdd1aa8d89d.png)

## Main features
* Build and design the hardware system on FPGA and embed programming on the HPS (ARM Cortex-A9).
* Utilize the Azure platform to expand IoT data processing, storage, and analysis capabilities.
* Program using registers to utilize IP core blocks such as UART, I2C, SPI.
* Read datasheets and write drivers for sensors.
* Write an app in Kotlin to control the device.
## Theoretical foundation
### Introduction to SoC FPGA
* SoC FPGA (System on Chip Field-Programmable Gate Array) is a type of integrated processor within a single chip.
* The primary function of FPGA is to create custom logic circuits to perform functions and process data as needed.
* HPS contains processing cores, such as ARM Cortex-A9, enabling users to build and execute embedded programs ranging from simple to complex.
![](https://user-images.githubusercontent.com/130819168/266976813-9769db47-ebb1-4594-b952-2bced86560d6.png)
* An AXI Bridge is a mechanism within the System on Chip FPGA (SoC FPGA) system used to connect and transmit data between the AXI (Advanced eXtensible Interface) interfaces on the main processing unit (HPS - Hard Processor System) and programmable hardware components (FPGA) on the same chip.
![](https://user-images.githubusercontent.com/130819168/266976835-86e2f973-face-48d2-9bd7-fb326a6d0701.png)
### Azure IoT Central
* Azure IoT Central is an application platform as a service (aPaaS) solution for building, deploying, and managing IoT solutions.
* The platform provides a web user interface (UI) as the main interface.
** Connect and monitor devices
** Equipment management
** Analys
** Create rules….
![](https://user-images.githubusercontent.com/130819168/266976983-f6f78caf-f585-4575-bf59-cc71e3a141ac.png)
### Methods of implementation
#### I2C Master Core
* I will program using registers with the following algorithm flowchart
![](https://user-images.githubusercontent.com/130819168/266977049-1c7093aa-fee5-4b8e-85b9-1ab34ceee416.png)
![](https://user-images.githubusercontent.com/130819168/266977074-c44bead0-3250-4bb2-ba3d-b2c2b9961ee2.png)
#### Communicate De10 with SHT30
* Measurement Commands in Single Shot Mode
![](https://user-images.githubusercontent.com/130819168/266977103-4d7ca3a9-6679-4ce1-b1b0-3fe720d2dc2f.png)
* Flow chart
![](https://user-images.githubusercontent.com/130819168/266977121-960dedd7-0ad2-4ae7-a823-9fb5e1ad1cfb.png)
#### Uart Core
* Register
![image](https://user-images.githubusercontent.com/130819168/266977174-386b9d77-c8f4-4c08-9c68-9beaf4dcc867.png)
* Programming Model Flowchart 
![image](https://user-images.githubusercontent.com/130819168/266977189-ace0bed4-e3d5-4d6e-a41a-f0f4c1ca3e53.png)
#### Communicate De10 with ESP8266
![](https://user-images.githubusercontent.com/130819168/266977272-37708c16-31ca-400b-9774-434c9d15620f.png)
### Build and access Azure IoT Central
#### Device test sample
![](https://user-images.githubusercontent.com/130819168/266977315-e7a01b81-68f3-4de0-8ec8-53f2a035269f.png)
#### Device
![](https://user-images.githubusercontent.com/130819168/266977337-7bc0f692-d2fe-4be1-b188-e94baec4fab7.png)
### Transmit and receive data from Azure IoT Central
#### Transmit data to IoT Central from De10
![](https://user-images.githubusercontent.com/130819168/266977367-1c65f981-3703-4be1-8899-dc865c66193f.png)
#### ESP8266 receives data from IoT Central
![](https://user-images.githubusercontent.com/130819168/266977388-bdbdb5d3-7e4f-4532-9d17-ed6cd99ee8c5.png)
### Azure Iot App to remotely control LEDs
![](https://user-images.githubusercontent.com/130819168/266977420-b66985e4-9e1e-4b3a-862f-85959ae6633b.png)
### Result
![](https://user-images.githubusercontent.com/130819168/266977604-a860cced-e11c-49c8-8bab-89ec71a1ddc3.png)
## Demo
![](https://user-images.githubusercontent.com/130819168/266977667-ce5f67f6-0d46-4d1f-b6bb-b3b97e7f2492.png)

#if you have any question, please contact me via

https://www.linkedin.com/in/havannghia/ or
https://www.facebook.com/H.V.N.0000



