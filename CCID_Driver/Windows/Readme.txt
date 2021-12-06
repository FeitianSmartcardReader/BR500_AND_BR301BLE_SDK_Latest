*Please confirm your bluetooth module on your PC support BLE Technology

2021/12/06
	1. Fixed bugs in Windows x86.
	2. Optimize the code by including and removing debugging information.
	3. BLE_CCID_Driver_1_Reader.exe-this driver supports 1 BLE reader only at the same time.
	BLE_CCID_Driver_2_Reader.exe-this driver supports 2 BLE reader only at the same time.
2021/11/10
	solved big data errors. When sending large data, the driver will return an error.
	Support 2 BLE reader at same time
2021/04/22
	Released V5 version, and now you can using 2 BLE reader with latest driver at the same time.
2021/01/14
	Improve the card reading speed
	Optimized card slot detection events
2020/12/03
	Fixed bug with PIV card support, which is T1 protocol
	Improve the stability
2020/3/23
	Fix big data communication error issue
2019/03/21
	Update driver file, support new and old reader for both.
	Upgrade the install manual
2019/03/20
	Update driver, add new bR301BLE and bR500 support, which upgraded the bluetooth module, change to new UUID
	Fix bug when disconnect the reader
2016/04/20
	The install manual will publish end of this month
2016/03/09
	Feitian publish two new product with Bluetooth BLE technology, bR301_BLE is chip card reader with BLE technology, and bR500 is contactless card with BLE technology, they are both is PC/SC reader, the driver also is CCID compatible, the driver using for windows which allow user to do bluetooth connection on windows. The driver is CCID driver which based on bluetooth framework, and on high level, user can call WINSCARD API to do opeartion reader.
	Any questions, contact FEITIAN anytime, mail is ben@ftsafe.com, thanks
