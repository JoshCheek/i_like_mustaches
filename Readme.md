ILikeMustaches
==============

Tool for quickly organizing / querying information about projects.

I use it by making a bin in my path which I edit with new notes.

    #!/usr/bin/env ruby

    $LOAD_PATH.unshift "/Users/joshcheek/code/i_like_mustaches/lib"

    require 'i_like_mustaches'


    i_like_mustches = ILikeMustaches.new do |mustache|
      i_like_mustaches.quick_note "123123", "Prod account_id", "database", "db", "production"
      i_like_mustaches.quick_note "ssh blah blah blah", "ssh into production server"
      i_like_mustaches.quick_note "1.2.3.4", "dns"
    end

    ILikeMustaches::Console.new(nc, ARGV, $stdin, $stdout, $stderr).call

If that was saved in `~/bin/app`, then `app 1` would return the first and third note, and `app 1 ~dns` would return only the first one.


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
