import dimscord, asyncdispatch, options

const
  ApplicationID = "785169831208681482"
  token         = slurp("../DiscordToken.txt")
  commandPrefix = "."

let
  discord = newDiscordClient(token)

proc runDiscordBot*() =
  echo "Running Discord server!"
  waitFor discord.startSession()

proc onReady(s: Shard, r: Ready) {.event(discord).} =
  # I reckon this is where you'd register commands once it's all connected.
  echo "Ready! I am ", $r.user
  echo "Registering commands!"

  discard discord.api.registerApplicationCommand(
    application_id = ApplicationID,
    name           = "ping",
    description    = "I'll respond with pong!",
  )

  discard discord.api.registerApplicationCommand(
    application_id = ApplicationID,
    name           = "embed",
    description    = "I will swear at you in an embed!",
  )

proc interactionCreate(s: Shard, i: Interaction) {.event(discord).} =
  if i.kind != itApplicationCommand: return
  if i.data.isNone: return

  if i.data.get().name == "ping":
    echo "Got a ping command!"

proc messageCreate(s: Shard, m: Message) {.event(discord).} =
  if m.author.bot: return
  if m.content == "!ping":
    discard await discord.api.sendMessage(m.channel_id, "Pong! (*fuck*)")
  elif m.content == "!embed":
    discard await discord.api.sendMessage(
      m.channel_id,
      embed = some Embed(
        title       : some "Fuck!",
        description : some "Shit!",
        color       : some 0xff5000
      )
    )
