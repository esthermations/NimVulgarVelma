import system, logging
import Globals, Twitch, Discord


proc VulgarVelma(discord = false, twitch = false) =
  setStdioUnbuffered()
  logging.addHandler(Globals.logger)

  if (discord): runDiscordBot(discordToken)
  if (twitch): runTwitchBot(twitchOAuthToken)

import cligen; dispatch(VulgarVelma)
