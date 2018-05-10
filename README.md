# nodemcu-traffic-lights

Simple traffick light script for the nodemcu firmware.

1. Instalar drivers:

https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers
Instruções de como instalar no .txt junto com o driver.

Portas seriais no ubuntu pertencem ao grupo dialout, para se colocar neste grupo basta usar o comando:

`sudo gpasswd --add <user> dialout`

2. Carregar código no firmware nodemcu:

https://github.com/andidittrich/NodeMCU-Tool

Para instalar:
`apt install npm`
`npm install nodemcu-tool -g`

ERRO `/usr/bin/env: node: No such file or directory`

Solução:  `ln -s /usr/bin/nodejs /usr/bin/node`

Para descobrir a porta em que o dispositivo está:

`./nodemcu-tool.js devices`

Criar uma nova partição:

`./nodemcu-tool.js mkfs --port=/dev/ttyUSB0`

Para fazer upload de um arquivo:

`./nodemcu-tool.js upload --port=/dev/ttyUSB0 helloworld.lua`

Para rodar um arquivo:

`./nodemcu-tool.js run --port=/dev/ttyUSB0 helloworld.lua`

Para remover um arquivo:

`file.remove('init.lua')`

3. Para visualizar a saída do dispositivo pela porta serial basta usar o gtkterm:

`gtkterm --port=/dev/ttyUSB0 --speed=115200`

## Usage

FIXME

## License

