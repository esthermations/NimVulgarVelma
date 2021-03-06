# Package

version       = "0.1.0"
author        = "Esther O'Keefe"
description   = "A bot for Discord and Twitch"
license       = "MIT"
srcDir        = "src"
bin           = @["VulgarVelma"]

# Dependencies
requires "nim >= 1.4.2"
requires "cligen >= 1.5.0"
requires "dimscord"
requires "irc >= 0.4.0"
