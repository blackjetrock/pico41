#!/usr/bin/tclsh
#
# Takes an HP41C program in text form and converts it into a form ready to be
# put into an HP41C using the Pico41. This uses presses of the keyboard to
# enter the program.
#
#
################################################################################
#
#

set ::EMBED_COMMENT_START "// HP41C_EMBEDDED_KEYS_START"
set ::EMBED_COMMENT_END   "// HP41C_EMBEDDED_KEYS_END"

set ::EMBED_COMMENT_START_PROG "// HP41C_EMBEDDED_PROG_START"
set ::EMBED_COMMENT_END_PROG   "// HP41C_EMBEDDED_PROG_END"

set emulator_filename  "pico41.c"


################################################################################

set ::KEYPRESSES {
    0     - {0}
    1     - {1}
    2     - {2}
    3     - {3}
    4     - {4}
    5     - {5}
    6     - {6}
    7     - {7}
    8     - {8}
    9     - {9}
    R/S   - {R/S}
    .     - {.}
    /     - {/}
    *     - {*}
    +     - {+}
    -     - {-}
    ENTER - {ENTER}
    CHS   - {CHS}
    EEX   - {EEX}
    <-    - {}
    SHIFT - {}
    XEQ   X {}
    STO   N {STO}
    RCL   N {RCL}
    SST   - {}
    X<>Y  - {X<>Y}
    RDN   - {RDN}
    SIN   - {SIN}
    COS   - {COS}
    TAN   - {TAN}
    E+    - {E+}
    1/X   - {1/X}
    SQRX  - {SQRX}
    LOG   - {LOG}
    LN    - {LN}
    USER  - {}
    PRGM  - {}
    ALPHA - {}
    LBL   L {}
    DEG   F {}
    MOD   F {}
    HMS   F {}
    INT   F {}
    LASTX F {}
    FRC   F {}
    DSE   N {XEQ ALPHA D S E ALPHA}
    ST+   N {STO +}
    ST-   N {STO -}
    ST*   N {STO *}
    ST/   N {STO /}
    X#Y?  - {XEQ ALPHA X SHIFT H Y 3 ALPHA}
    X<0?  - {XEQ ALPHA X SHIFT I SHIFT 0 3 ALPHA}
    E2    - {1 EEX 2}
    E3    - {1 EEX 3}
    "\"\"" - {XEQ ALPHA N O P ALPHA}
    A     - {}
    B     - {}
    C     - {}
    D     - {}
    E     - {}
    F     - {}
    G     - {}
    H     - {}
    I     - {}
    J     - {}
    K     - {}
    L     - {}
    M     - {}
    N     - {}
    O     - {}
    P     - {}
    Q     - {}
    R     - {}
    S     - {}
    T     - {}
    U     - {}
    V     - {}
    W     - {}
    X     - {}
    Y     - {}
    Z     - {}
    =     - {}
    ?     - {}
    :     - {}
}

################################################################################

# Presses an alpha string
# Numbers need to be shifted

proc alpha_string {str} {
    set press ""
    
    append press "\nALPHA "
    set name [split [string trim $str "\""] ""]

    foreach chr $name {
	switch $chr {
	    0 -
	    1 -
	    2 -
	    3 -
	    4 -
	    5 -
	    6 -
	    7 -
	    8 -
	    9 {
		append press "SHIFT "
	    }
	}
	append press "$chr "
    }
    
    append press "\nALPHA "
    
    return $press
}

################################################################################
#
# Open the text that we want to convert and load it

set fn [lindex $argv 0]
set f [open $fn]
set txt [read $f]
close $f

puts "Filename:$fn"

# Tidy up the text version of the program
#
# We want just instructions and the step number
#
set newtxt ""

foreach line [split $txt "\n"] {
    # Trim spaces
    set line [string trim $line " "]


    # Remove any line that doesn't have a step number at the start
    if { ![regexp -- {^[0-9]+} $line] } {
	continue	
    }
    
    puts "'$line'"
    append newtxt "\n$line"
}

puts $newtxt

# To remove comments reliably we need to parse the instructions and
# discard anything that isn't code.
set presstxt ""
set progtxt ""

foreach line [split $newtxt "\n"] {
    puts "I $line"
    set press ""
    set progln ""
    
    if { [regexp -- {([0-9]+)[ ]+([^ ]+)} $line all stepno firstword] } {
	
	set found 0
	puts "$stepno $firstword"
	append progln "$stepno "
	
	# Check for a number
	if { [regexp -- {^[0-9.]+$} $firstword all] } {
	    # Press the digits
	    foreach key [split $firstword ""] {
		append presstxt "$key "
	    }
	    append progln "$firstword"
	    set found 1
	}
	
	foreach {inst code presses} $::KEYPRESSES {
#	    puts "COMPARE: '$firstword' '$inst'"		
	    if { [string compare $firstword $inst] == 0 } {
		puts "MATCH: '$firstword' '$inst'"		

		# Press any direct mapping keys before the code action
		set press ""
		foreach k $presses {
		    puts "Inserting press:$k"
		    append presstxt "$k "
		}

		switch $code {
		    - {
			append progln "$firstword"
			set found 1
		    }
		    
		    L {
			
			if { [regexp -- {([0-9]+)[ ]+([^ ]+)[ ]+(.+)} $line all stepno firstword labelname] } {
			    puts "Label '$labelname'"
			    
			    set press "SHIFT STO "
			    set found 1
			    switch -regexp $labelname {
				"\"[A-Z0-9]+\"" {
				    # Type an alpha label
				    puts "Alpha label"
				    append press [alpha_string $labelname]
				    append progln "$firstword\G[string trim $labelname "\""]"
				}
				"[0-9]{2}" {
				    # Type a numeric label
				    set name [split $labelname ""]
				    foreach n $name {
					append press "$n "
					append progln "$firstword $labelname"
				    }

				}
				default {
				    puts "Unknown label name type"
				    exit
				}
			    }
			}
		    }

		    N {
			
			if { [regexp -- {([0-9]+)[ ]+([^ ]+)[ ]+(.+)} $line all stepno firstword labelname] } {
			    puts "Label '$labelname'"
			    
			    set press ""
			    set found 1

			    switch -regexp $labelname {
				"\"[A-Z0-9]+\"" {
				    # Type an alpha label
				    puts "Alpha label"
				    append press [alpha_string $labelname]
				    append progln "$firstword\G[string trim $labelname "\""]"
				}
				"[0-9]{2}" {
				    # Type a numeric label
				    puts "Numeric label"
				    set name [split $labelname ""]
				    foreach n $name {
					append press "$n "
				    }
				    append progln "$firstword $labelname"
				}

				X {
				    append press ". X "
				    append progln "$firstword $labelname"
				}

				Y {
				    append press ". Y "
				    append progln "$firstword $labelname"
				}
				
				default {
				    puts "Unknown label name type '$labelname'"
				    exit
				}
			    }
			}
		    }
		    
		    F {
			if { [regexp -- {([0-9]+)[ ]+([^ ]+)} $line all stepno firstword] } {
			    puts "Function '$firstword'"
			    set press "XEQ "
			    set found 1

			    switch -regexp $firstword {
				"[A-Z0-9]+" {
				    append press [alpha_string $firstword]
				    append progln "$firstword"
				}
			    }
			}
		    }
		    
		    X {
			if { [regexp -- {([0-9]+)[ ]+([^ ]+)[ ]+(".+")} $line all stepno firstword xeqname] } {
			    puts "Xeq '$xeqname'"

			    set press "XEQ "
			    set found 1
			    switch -regexp $xeqname {
				"\"[A-Z0-9]+\"" {
				    # Type an alpha xeq
				    puts "Quoted Alpha xeq"
				    append press [alpha_string $xeqname]
				    append progln "$firstword\G[string trim $xeqname "\""]"
				}
				"^[A-Z0-9]+$" {
				    # Type an alpha function
				    puts "Unquoted Alpha xeq"
				    append press [alpha_string $xeqname]
				    append progln "$firstword $xeqname"
				}

			    }
			}
		    }
		}
	    }
	    
	    if { $found } {
		puts "Found: $line"
		puts $press
		append presstxt "\n$press"

		# Modify some characters we don't display correctly
		set progln [string map {"#" "M"} $progln]

		lappend progtxt $progln
		break
	    }
	}
    }
}

puts "$presstxt"
puts "$progtxt"

################################################################################

# Embed the keypresses

set presses ""
set n 0
foreach key $presstxt {
    append presses "\"$key\", "
    incr n 1
    if { [expr ($n % 8) == 0 ] } {
	append presses "\n"
    }
}

# Embed the program for checking
set program_steps ""
set n 0
foreach progline $progtxt {
    append program_steps "\"$progline\", "
    incr n 1
    if { [expr ($n % 8) == 0 ] } {
	append program_steps "\n"
    }
}


puts "Embedding keypresses in C file:$::emulator_filename"

set f [open $emulator_filename]
set embed_text [read $f]
close $f

regsub "$::EMBED_COMMENT_START\(.*)$::EMBED_COMMENT_END" $embed_text "$::EMBED_COMMENT_START\n$presses\n$::EMBED_COMMENT_END" embed_text2

set g [open $::emulator_filename w]
puts -nonewline $g $embed_text2
close $g

puts "Embedding program in C file:$::emulator_filename"

set f [open $emulator_filename]
set embed_text [read $f]
close $f

regsub "$::EMBED_COMMENT_START_PROG\(.*)$::EMBED_COMMENT_END_PROG" $embed_text "$::EMBED_COMMENT_START_PROG\n$program_steps\n$::EMBED_COMMENT_END_PROG" embed_text2

set g [open $::emulator_filename w]
puts -nonewline $g $embed_text2
close $g
