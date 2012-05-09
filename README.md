# HopShop
HopShop is a GUI client for [Homebrew][hb]. It's in early alpha stage. Right now, it shows available formulae and installed formulae only. It's early alpha, and startup is a problem that will be fixed soon (it's awfully slow to start).

It's written in Objective-C and is compiled for Snow Leopard or later. It eventually might get bumped up to Lion-only, but not before my work Mac is upgraded to Lion (or Mountain Lion).

## Origin
HopShop was inspired by and forked from [Vincent Saluzzo's][vs] [Homebrew-GUI][hbg].

## Roadmap
HopShop will eventually be a full GUI front end for HomeBrew, which also must be installed on your system.

Not a lot is set in stone. I don't know if there should be a toolbar, or the little +/- buttons to add and remove formulae. Some things I plan to add:

* Indication of which formulae are installed in the Available Formulae list (not display them in list? Display them but with a green checkmark? Not sure)
* sudo support for those who need it
* Colorful info panel that's easier to read (formula name in bold, Caveats highlighted, blank lines between multiple selections, etc)
* Maybe search for installed formulae as well--not sure how necessary that is
* Install/uninstall/update/upgrade

## Contributing

Fork it, make your changes, and send me a pull request!

## Self-promotion
Follow me on my [blog][blog] or on [Twitter][twitter].

[hb]: http://mxcl.github.com/homebrew/
[vs]: https://github.com/vincentsaluzzo
[hbg]: https://github.com/vincentsaluzzo/Homebrew-GUI
[blog]: http://grailbox.com
[twitter]: http://twitter.com/hoop33