#Get nic info

sysctl -a | grep dev.em. | sed 's/\:/\ \=/g' | logger
