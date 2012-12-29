ILikeMustaches
==============

Tool for quickly organizing / querying information about projects.

I use it by making a bin in my path which I edit with new notes.

Currently there are only `quick_notes`, but hoping to add other useful types later. A quick note consists of a key, value, and set of tags.

```ruby
#!/usr/bin/env ruby

$LOAD_PATH.unshift "/Users/joshcheek/code/i_like_mustaches/lib"

require 'i_like_mustaches'


i_like_mustches = ILikeMustaches.new do |mustache|

  # for the help screen
  mustache.description = "Example application"

  #                   key       value              .----------- tags -----------.
  mustache.quick_note "123123", "Prod account_id", "database", "db", "production"
  mustache.quick_note "ssh blah blah blah", "ssh into production server"
  mustache.quick_note "1.2.3.4", "dns"
end

# default wiring uses ARGV, $stdout, $stderr, and config file from ~/.i_like_mustches
ILikeMustaches::Console.new(i_like_mustches).call
```

If that was saved in `~/bin/app`, then `app 1` would return the first and third note because they both have "1" in them, and `app 1 ~dns`
would return only the first one, because a leading tilde is considered to be a negated matcher, and the third note matches "dns".

Configuration
=============

Check [`lib/i_like_mustches/configuration.rb`](https://github.com/JoshCheek/i_like_mustaches/blob/ca43fccf6821ce3d6083c17911064e49b67a2a8a/lib/i_like_mustaches/configuration.rb) to see all options.

By default, ILikeMustaches will look in `~/.i_like_mustaches` for a configuration file. Here is mine:

```ruby
ILikeMustaches.configure do |config|
  config.should_colour        = true
  config.quick_note_separator = "    "
end
```

License
=======

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                        Version 2, December 2004

     Copyright (C) 2012 Josh Cheek <josh.cheek@gmail.com>

     Everyone is permitted to copy and distribute verbatim or modified
     copies of this license document, and changing it is allowed as long
     as the name is changed.

                DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
       TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

      0. You just DO WHAT THE FUCK YOU WANT TO.
