import system
import Twitch, Discord

proc VulgarVelma(discord = false, twitch = false) =
  setStdioUnbuffered()

  if (discord): runDiscordBot()
  if (twitch): runTwitchBot()

import cligen; dispatch(VulgarVelma)
