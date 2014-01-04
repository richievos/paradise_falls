# Paradise Falls

After you go Up, make sure to visit Paradise Falls.

A library and Controller for Up printers. This should work for [Up Plus](http://www.pp3dp.com/index.php?page=shop.product_details&flypage=flypage.tpl&product_id=10&category_id=1&option=com_virtuemart&Itemid=37), [Up mini](http://www.pp3dp.com/index.php?page=shop.product_details&flypage=flypage.tpl&product_id=6&category_id=1&option=com_virtuemart&Itemid=37), and [Afinias](http://www.afinia.com/).

Usage:

    bin/dug command

## References

* [pp3dp forums](http://www.pp3dp.com/forum/viewforum.php?f=10)
* https://www.thekua.com/atwork/2012/05/usb-programming-with-ruby/
* http://www.beyondlogic.org/usbnutshell/usb6.shtml
* [libusb rdocs](http://rubydoc.info/gems/libusb/frames)
* [libusb source](https://github.com/larskanis/libusb)

Ones I haven't really gone through yet, but come recommended:

* [USB Made Simple](http://www.usbmadesimple.co.uk/)
* [USB Complete](http://www.lvr.com/usbc.htm)
* [PyUSB docs](http://pyusb.sourceforge.net/docs/1.0/tutorial.html) — seems to be more info about this than the ruby libusb driver

## USB reverse engineering
* [vusb-analyzer tutorial](http://vusb-analyzer.sourceforge.net/tutorial.html)
* [more recent version of vusb-analyzer](https://github.com/vpelletier/vusb-analyzer) — the SF version doesn't handle

## Approximate milestones

+ [x] Initialize a turned off/on Up
* [ ] Read important kick off print settings
  * [ ] Platform temperature
  * [ ] Print time left (if this is on the device)
  * [ ] Current status (printing or not)
  * [ ] Extruder temperature
* [ ] Read some misc print settings
  * [ ] Platform Height
* [ ] Cut v0.1.0 of the gem

## History

* [Original forum post talking about a similar idea](http://www.pp3dp.com/forum/viewtopic.php?f=28&t=22192&start=40)
* [sfinktah's original python driver](https://github.com/sfinktah/uptempo). Note there are likely differences between the two implementations. This variant is being built from scratch so that I learn more about USB and the Up.

## General props

Major props go to sfinktah on the [pp3dp.com forums](http://www.pp3dp.com/forum/viewforum.php?f=10) for doing his initial take on this type of thing.

Also props to [Dan Nawara](https://github.com/danboy) for the great name "paradise falls".

Finally, props to [Inventables](http://www.inventables.com) for being a great place for 3d printer supplies, and being fast with the customer service when I have issues.