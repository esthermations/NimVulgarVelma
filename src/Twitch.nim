import net, irc, strformat, strutils, sugar

type
  Milliseconds = int # for readability in timeouts
  CommandResponse = proc(e: IrcEvent): string

  CommandName {.pure.} = enum
    Hello
    Lurk

const
  commandPrefix = "!"
  oauthToken = slurp("../TwitchOAuthToken.txt")
  botName = "VulgarVelma"
  channel = "#esthermations"

  commands = [
    Hello: (e: IrcEvent) => fmt"Hello, {e.nick}",
    Lurk: (e: IrcEvent) => fmt"Have a nice lurk, {e.nick}!"
  ]

func messageText(e: IrcEvent): string =
  assert e.typ == EvMsg
  e.params[e.params.len - 1]

proc handleMessage(c: Irc, e: IrcEvent) =
  if e.nick.len == 0: return

  var text = e.messageText()

  if not text.startsWith(commandPrefix):
    return

  text.delete(0, commandPrefix.len - 1)
  let cmd = parseEnum[CommandName](text.capitalizeAscii())
  echo "Got command: ", cmd

  let response = commands[cmd](e)
  c.privmsg(channel, response)

proc runTwitchBot*() =
  let
    c = newIrc(
      address    = "irc.twitch.tv",
      port       = 6667.Port,
      nick       = botName,
      user       = botName,
      serverPass = oauthToken,
      joinChans  = @[channel]
    )

  c.connect()
  echo "Called connect()!"

  while true:
    var event: IrcEvent
    if c.poll(event, timeout = 500.Milliseconds):
      case event.typ:
      of EvConnected:
        echo "Connected!"
      of EvDisconnected:
        echo "Disconnected."
      of EvMsg:
        echo fmt"{event.nick}: {event.messageText()}"
        c.handleMessage(event)
      else:
        echo "Other event."
    else:
      discard

