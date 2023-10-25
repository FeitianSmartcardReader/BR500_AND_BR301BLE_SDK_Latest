For bR301 BLE and bR500 using same update tool, the different is firmware name.

2023/10/25
  Update the bR301BLE firmware to 2.25, here are some details:
  1. Support enable/disable auto power off feature.
  2. Support obtain the battery remaining capacity.
  3. Communication speed improvement.

2019/10/10
  Update the bR301BLE firmware to 2.20, which support new hardware bR301FC6, few changes for the new version:
  1. It adds battery service on Bluetooth boardcast, you can get the battery level easily through this service.
  2. old version which called bR301FC4, the bluetooth module already stop production, so we upgrade the module to new version, which the UUID also different, if the comminucation library made by you, you may need change the UUID, below is two UUIDs:
    DEFINE_GUID(FTBTRDLE_UUID_C4, 0x46540001, 0x0002, 0x00c4, 0x00, 0x00, 0x46, 0x54, 0x53, 0x41, 0x46, 0x45);
    DEFINE_GUID(FTBTRDLE_UUID_C6, 0x46540001, 0x0002, 0x00c6, 0x00, 0x00, 0x46, 0x54, 0x53, 0x41, 0x46, 0x45);
  3. Change the rules of the light means
      - without pairing, the blue light flashing, after pair, the blue light turn on
      - when detect the card, the green light turn on, remove card will turn off, if there have communication, the green light flashing
      - battery charging the red light will trun on, after the full charging, the red light turn off

Please notice, you cannot update bR301FC4 to new firmware, because it has compatible issue.

2017/8/25 When connected to charger, it works do pair at first time, the second time has issue, App cannot found reader, this issue already solved in 1.11 version, it is beta version.
2017/3/14 Update firmware to 1.10, fix issue when using Feitian Bluetooth CCID driver, the behave is read card data error and give 40FE error.
