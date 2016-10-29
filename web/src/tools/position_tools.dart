import 'dart:math';

class PositionTools {

  /// Projection d'un carré dans un cercle. si x et y représente une position
  /// dans un carré de taille  width et height, les x et y sortant sont cette
  /// même position après qu'on ai "arrondi" le carré en écrasant ses 4 coins.
  static Point squareToCircle(num x, num y, num width, num height)
  {
    num xSquare;
    num halfWidth = width * 0.5;
    if (x == halfWidth) xSquare = 0;
    else if (x < halfWidth) xSquare = -(halfWidth - x) / halfWidth;
    else xSquare = (x - halfWidth) / halfWidth;

    num ySquare;
    num halfHeight = height * 0.5;
    if (y == halfHeight) ySquare = 0;
    else if (y < halfHeight) ySquare = -(halfHeight - y) / halfHeight;
    else ySquare = (y - halfHeight) / halfHeight;

    num xCircle = xSquare * sqrt(1 - 0.5 * pow(ySquare, 2));
    num yCircle = ySquare * sqrt(1 - 0.5 * pow(xSquare, 2));

    return new Point(xCircle * halfWidth + halfWidth, yCircle * halfHeight + halfHeight);
  }

}