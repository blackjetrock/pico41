#!/usr/bin/tclsh
#
# Embeds a binary file as a C array in the emulator code
#
#

set ::EMBED_COMMENT_START "// HP41C_ROM_EMBEDDED_CODE_START"
set ::EMBED_COMMENT_END   "// HP41C_EMBEDDED_CODE_END"

#
# The name of the rom file is the only argument.
#

set rom_filename       [lindex $argv 0]
set emulator_filename  "pico41.c"

# Open and read the files
set f [open $rom_filename]
fconfigure $f -translation binary

set rom_data [read $f]
close $f

set f [open $emulator_filename]
set embed_text [read $f]
close $f


# Format the code as C array hex
#
# Every two bytes is truned into a 10 bit value that is stored as a
# uint16_t
#

set f_hex ""
set f_i 0
foreach {bytea byteb} [split $rom_data ""] {
    binary scan $bytea H* hexa
    binary scan $byteb H* hexb
    
    append f_hex "0x$hexa$hexb,"
    incr f_i 1
    if { ($f_i % 16) == 0 } {
	append f_hex "\n"
    }
}

# Embed the code

puts "Embedding object code in C file:$::emulator_filename"

regsub "$::EMBED_COMMENT_START\(.*)$::EMBED_COMMENT_END" $embed_text "$::EMBED_COMMENT_START\n$f_hex\n$::EMBED_COMMENT_END" embed_text2

set g [open $::emulator_filename w]
puts -nonewline $g $embed_text2
close $g

