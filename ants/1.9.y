#%Module1.0#####################################################################
# $Id: $
##
## ants modulefile
##

set version "1.9.y"
set package ants
set PACKAGE ANTS
set dist [exec lsb_release -i | tr "\t" " " | cut -d " " -f 3]
set rel  [exec lsb_release -r | tr "\t" " " | cut -d " " -f 2 | cut -d "." -f 1]
set distrel $dist$rel
set pkghome /usr/local/tools/$package/$version/$distrel

#puts stderr "package = $package"
#puts stderr "PACKAGE = $PACKAGE"
#puts stderr "version = $version"
#puts stderr "distrel = $distrel"
#puts stderr "pkghome = $pkghome"

conflict ants

set mode [module-info mode]
set shelltype [module-info shelltype]

if {$mode == "load"} {
  if {[is-loaded $package]} {
    puts stderr "ERROR: $package is already loaded. Try unload it first."
    exit 1
  }
}
if {$mode == "remove"} {
}

if {![file isdirectory $pkghome]} {
	puts stderr "No installation of $PACKAGE ($version)"
	exit 1 
}

proc ModulesHelp { } {
	puts stderr "\tSet up environment for $package version $version\n"
}

module-whatis "Set up environment for $package version $version"

global env

setenv ANTS_DIR $pkghome
#puts stderr $env(ANTS_DIR)

if {[file isdirectory /usr/local/tools/$package/$version/$distrel/bin]} {
  prepend-path PATH /usr/local/tools/$package/$version/$distrel/bin
}

#set-alias ants {${ANTS_DIR}/bin/$*}
if {$mode == "load"} {
  if {[string compare $env(ANTS_DIR) ""] == 0} {
    puts stderr "ERROR: must set 'ANTS_DIR' environment variable to $PACKAGE install directory"
    exit 1
  }

  if {$shelltype == "sh"} {
    puts "function ants() { $\{ANTS_DIR\}/bin/$*; };"
    puts "export -f ants;"
  }
}
if {$mode == "remove"} {
  if {$shelltype == "sh"} {
    puts "unset -f ants;"
  }
}

