# Dijeweled Server

A dedicated GUI server application for [Dijeweled Remastered](https://github.com/LDinos/Dijeweled).
In order to succesfully make your server accessible, make sure to port forward your IPV4 adress and port : 6969

## General Info

The server has some simple features. The folder where files are kept are in %appdata%/Local/bej_temp_server

### Logging system

The server is keeping logs in real time. When you exit the program, the latest log is kept in a text file called LOG.txt

### Replay system

The server starts capturing frames of user activities while running in-game. After a match succesfully ends, the latest replay file will be stored in a json file as replay.json. Furthermore, the replay is sent to the users connected to the game (including spectators)