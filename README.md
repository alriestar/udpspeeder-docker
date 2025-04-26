# UDPSpeeder on docker

This just another docker build UDPSpeeder use wolfi as base image

thanks to:

[https://github.com/wangyu-/UDPspeeder](https://github.com/wangyu-/UDPspeeder)

[https://github.com/wolfi-dev/](https://github.com/wolfi-dev/)

and other

Primarily uses Docker Compose but can also use Docker run 

### Help

```bash
$ docker run --rm  ghcr.io/alriestar/udpspeeder --help
UDPspeeder V2
git version: 61b24a3697    build date: Feb  7 2023 09:25:11
repository: https://github.com/wangyu-/UDPspeeder

usage:
    run as client: ./this_program -c -l local_listen_ip:local_port -r server_ip:server_port  [options]
    run as server: ./this_program -s -l server_listen_ip:server_port -r remote_ip:remote_port  [options]

common options, must be same on both sides:
    -k,--key              <string>        key for simple xor encryption. if not set, xor is disabled
main options:
    -f,--fec              x:y             forward error correction, send y redundant packets for every x packets
    --timeout             <number>        how long could a packet be held in queue before doing fec, unit: ms, default: 8ms
    --report              <number>        turn on send/recv report, and set a period for reporting, unit: s
advanced options:
    --mode                <number>        fec-mode,available values: 0,1; mode 0(default) costs less bandwidth,no mtu problem.
                                          mode 1 usually introduces less latency, but you have to care about mtu.
    --mtu                 <number>        mtu. for mode 0, the program will split packet to segment smaller than mtu value.
                                          for mode 1, no packet will be split, the program just check if the mtu is exceed.
                                          default value: 1250. you typically shouldnt change this value.
    -j,--jitter           <number>        simulated jitter. randomly delay first packet for 0~<number> ms, default value: 0.
                                          do not use if you dont know what it means.
    -i,--interval         <number>        scatter each fec group to a interval of <number> ms, to defend burst packet loss.
                                          default value: 0. do not use if you dont know what it means.
    -f,--fec              x1:y1,x2:y2,..  similiar to -f/--fec above,fine-grained fec parameters,may help save bandwidth.
                                          example: "-f 1:3,2:4,10:6,20:10". check repo for details
    --random-drop         <number>        simulate packet loss, unit: 0.01%. default value: 0.
    --disable-obscure     <number>        disable obscure, to save a bit bandwidth and cpu
    --disable-checksum    <number>        disable checksum to save a bit bandwdith and cpu
developer options:
    --fifo                <string>        use a fifo(named pipe) for sending commands to the running program, so that you
                                          can change fec encode parameters dynamically, check readme.md in repository for
                                          supported commands.
    -j ,--jitter          jmin:jmax       similiar to -j above, but create jitter randomly between jmin and jmax
    -i,--interval         imin:imax       similiar to -i above, but scatter randomly between imin and imax
    -q,--queue-len        <number>        fec queue len, only for mode 0, fec will be performed immediately after queue is full.
                                          default value: 200.
    --decode-buf          <number>        size of buffer of fec decoder,unit: packet, default: 2000
    --delay-capacity      <number>        max number of delayed packets, 0 means unlimited, default: 0
    --disable-fec         <number>        completely disable fec, turn the program into a normal udp tunnel
    --sock-buf            <number>        buf size for socket, >=10 and <=10240, unit: kbyte, default: 1024
    --out-addr            ip:port         force all output packets of '-r' end to go through this address, port 0 for random port.
    --out-interface       <string>        force all output packets of '-r' end to go through this interface.
log and help options:
    --log-level           <number>        0: never    1: fatal   2: error   3: warn
                                          4: info (default)      5: debug   6: trace
    --log-position                        enable file name, function name, line number in log
    --disable-color                       disable log color
    -h,--help                             print this help message

```

### Running with the docker run command

```bash
docker run --name server --network host --restart unless-stopped -d ghcr.io/alriestar/udpspeeder:latest \
  -s -l 0.0.0.0:6000 -r 127.0.0.1:54321 -f 20:10 -k "mypassword" --mode 0 --timeout 0
```

In my case, I am using it with WireGuard for testing purposes only

### For Docker Compose

```bash
services:
  udpspeeder-server:
    image: ghcr.io/alriestar/udpspeeder:latest
    container_name: udpspeeder-server
    command: -s -l 0.0.0.0:6000 -r 127.0.0.1:54321 -f 20:10 -k "mypassword" --mode 0 --timeout 0
    network_mode: host
    restart: unless-stopped
```

Like that, since managing from binary is difficult, I created a Docker version hoping it would be more dynamic and scalable for mesh network via WireGuard for my setup.
