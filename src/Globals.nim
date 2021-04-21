import logging

const
  twitchOAuthToken* = slurp("../secrets/TwitchOAuthToken.txt")
  discordToken*     = slurp("../secrets/DiscordToken.txt")

var
  logger* = newConsoleLogger(fmtStr="$levelname | ")