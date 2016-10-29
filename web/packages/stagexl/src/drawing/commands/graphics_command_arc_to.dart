part of stagexl.drawing;

class GraphicsCommandArcTo extends GraphicsCommand {

  double _controlX;
  double _controlY;
  double _endX;
  double _endY;
  double _radius;

  GraphicsCommandArcTo(
      num controlX, num controlY,
      num endX, num endY, num radius)

      : _controlX = controlX.toDouble(),
        _controlY = controlY.toDouble(),
        _endX = endX.toDouble(),
        _endY = endY.toDouble(),
        _radius = radius.toDouble();

  //---------------------------------------------------------------------------

  double get controlX => _controlX;

  set controlX(double value) {
    _controlX = value;
    _invalidate();
  }

  double get controlY => _controlY;

  set controlY(double value) {
    _controlY = value;
    _invalidate();
  }

  double get endX => _endX;

  set endX(double value) {
    _endX = value;
    _invalidate();
  }

  double get endY => _endY;

  set endY(double value) {
    _endY = value;
    _invalidate();
  }

  double get radius => _radius;

  set radius(double value) {
    _radius = value;
    _invalidate();
  }

  //---------------------------------------------------------------------------

  @override
  void updateContext(GraphicsContext context) {
    context.arcTo(controlX, controlY, endX, endY, radius);
  }

}
