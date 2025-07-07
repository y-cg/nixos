# Home-Assistant

## Networking

home-assistant does **NOT** store all its states in the config. For instance `network adapter` is configurated in UI (See [docs](https://www.home-assistant.io/docs/configuration/basic/)) and only visible if you enable **Advanced mode**. This config is critial and **most of the time** home-assistant use the wrong one. As for the current installation, you need to switch it to `eth0` if you use ethernat cable or `wlan` if you are connected to wifi. Wrong configuration may lead to the failure of pairing *Home Bridge*.
