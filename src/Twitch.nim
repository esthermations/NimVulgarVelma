import net, logging, irc, strformat, strutils, sugar, sequtils

type
  Milliseconds = int # for readability in timeouts

  Command = object
    condition*: proc(e: IrcEvent): bool
    response*: proc(e: IrcEvent): string

const
  botName* = "Hogsby"
  commandPrefix = "!"
  channel = "#esthermations"

func containsCaseInsensitive*(haystack, needle: string): bool =
  haystack.toLower().contains(needle.toLower())

func isCommand(e: IrcEvent, commandName: string): bool =
  e.text.startsWith(commandPrefix & commandName)

func isHumanCommand(e: IrcEvent, keywords: seq[string]): bool =
  e.text.containsCaseInsensitive(botName) and
  keywords.anyIt(e.text.containsCaseInsensitive(it))

template simpleCommand(keyword, responseFmtStr: untyped): untyped =
  Command(condition: (e: IrcEvent) => e.isCommand(keyword),
          response : (e: IrcEvent) => &responseFmtStr)

template humanCommand(keywords, responseFmtStr: untyped): untyped =
  Command(condition: (e: IrcEvent) => e.isHumanCommand(keywords),
          response : (e: IrcEvent) => &responseFmtStr)

const commands = [
  humanCommand(
    keywords = @["hello", "hi", "greetings"],
    responseFmtStr = "Hello, {e.nick}, wonderful to see you."
  ),
  humanCommand(
    keywords = @["lurk"],
    responseFmtStr = "Enjoy your lurk, {e.nick}, we appreciate you being here."
  ),
  humanCommand(
    keywords = @["bye", "goodbye", "see you later"],
    responseFmtStr = "Bye {e.nick}, see you soon! :)"
  )
]

proc handleMessage(c: Irc, e: IrcEvent) =
  if e.nick.len == 0: return

  for command in commands:
    if command.condition(e):
      let response = command.response(e)
      info "Responding with: ", response
      c.privmsg(channel, response)

proc runTwitchBot*(oauthToken: string) =
  echo "Connecting with OAuth Token [", oauthToken, "]"

  let c = newIrc(
    address    = "irc.twitch.tv",
    port       = 6667.Port,
    nick       = botName,
    user       = botName,
    serverPass = oauthToken,
    joinChans  = @[channel]
  )

  info "Commands: ", commands

  c.connect()
  info "Called connect()!"

  while true:
    var event: IrcEvent
    if c.poll(event, timeout = 500.Milliseconds):
      case event.typ:
      of EvConnected:
        info "Connected!"
      of EvDisconnected:
        info "Disconnected."
      of EvMsg:
        info fmt"{event.nick}: {event.text}"
        c.handleMessage(event)
      else:
        info "Event: ", event
    else:
      discard
