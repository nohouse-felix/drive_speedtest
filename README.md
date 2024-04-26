# Drive Speedtest
## A user friendly bash script which evaluates the average read speed of a storage device using hdparm
![Picture of a penguin style USB drive](penguin_usb.jpg)

This scripts uses the package 'hdparm' to evaluate the read speed of a specified drive present in the system.
It does so three times and then calculates the average read speed out of these three results.

The user gets prompted to enter in the needed information, so no manual calculation or other terminal work is needed.

After cloning/downloading the script, simply make it executable by issuing the following command, assuming your current working directory is the one containing the script:
```bash
chmod +x drive_test.sh
```
and then run with sudo:
```bash
sudo ./drive_test.sh
```
