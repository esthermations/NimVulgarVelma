import unittest
import Twitch

test "containsCaseInsensitive":
  check "hello hogsby".containsCaseInsensitive(botName)
  check "hello hogsby".containsCaseInsensitive("hello")