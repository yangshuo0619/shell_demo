# shell demo

## check_net

## net bridge

## shell command

### 1、查看cpu温度
```
cat /sys/class/thermal/thermal_zone0/temp
```
### 2、udev生效（未生效）
```
sudo udevadm control --reload-rules && sudo udevadm trigger 
```

### 3、查看信息
```
udevadm info --query=all --name=/dev/video0
```
