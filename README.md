# Piron Games Haxe/Flash GameLib

A game library written in Haxe 2, targeting Flash. Since Flash is dead, this is only released for historical purposes.

Main features:
* UI support via microvcl;
* Sentry sprites loading and rendering;
* localization (use StringTool provided in gametoolkit module with StringScript_AS30_ByteArray.csl export script to export data from a master sheet to a format usable by the library).

The library was used between 2008-2010 to develop some of the early Adobe Flash games made by Piron Games, namely: [Born Of Fire TD](https://www.pirongames.com/born-of-fire-td/), [Orbital Decay](https://www.pirongames.com/orbital-decay/), [Ninjas!](https://www.pirongames.com/ninjas/), [That Word Game](https://www.pirongames.com/that-word-game/) and [Invisible Ink](https://www.pirongames.com/invisible-ink/)

It was superseded around 2010 by [hxgamelib2](https://github.com/stefandee/hxgamelib2), a much more complex game dev library.

A port to Haxe 3 and OpenFL was made in 2018, with the aim of releasing the aforementioned games to modern platforms like HTML5. It may be found at [hxgamelib-openfl](https://github.com/stefandee/hxgamelib-openfl).

## Setup (General)

This project uses submodules and they need to be initialized. 

After cloning the project, run:

```
git submodule init
git submodule update
```

Alternatively, pass --recurse-submodules to git clone (or tick the box in your clone popup if you have a visual git client).

## Usage
Source code works for Haxe 2.05 targeting Flash. Never been tested with other targets.

## License

Code license:
https://opensource.org/licenses/MIT

