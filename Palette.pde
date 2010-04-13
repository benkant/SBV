/**
 * $Id: Palette.pde 27 2008-12-11 07:08:54Z btgiles $
 *
 * Copyright (C) 2008 Ben Giles
 * btgiles@gmail.com
 *
 * Released under the GPL, Version 3
 * License available here: http://www.gnu.org/licenses/gpl.txt
 */

class Palette {
  color[] _colors = new color[6];

  Palette() {
    _colors[0] = #FF0066;
    _colors[1] = #00FF00;
    _colors[2] = #000000;
    _colors[3] = #FFFFFF;
    _colors[4] = #6633CC;
    _colors[5] = #00FFFF;
  }

  color getRandom() {
    return (color) _colors[int(random(0, _colors.length))];
  }
}

