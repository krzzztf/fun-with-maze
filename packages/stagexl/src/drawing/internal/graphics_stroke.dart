part of stagexl.drawing;

class _GraphicsStroke extends _GraphicsMesh {

  final double width;
  final JointStyle jointStyle;
  final CapsStyle capsStyle;

  _GraphicsStroke(_GraphicsPath path, this.width, this.jointStyle, this.capsStyle) {
    for (var pathSegment in path.segments) {
      segments.add(new _GraphicsStrokeSegment(this, pathSegment));
    }
  }

  //---------------------------------------------------------------------------

  @override
  void fillColor(RenderState renderState, int color) {
    for (_GraphicsStrokeSegment segment in segments) {
      segment.fillColor(renderState, color);
    }
  }

  @override
  bool hitTest(double x, double y) {
    for (_GraphicsStrokeSegment segment in segments) {
      if (segment.checkBounds(x, y) == false) continue;
      if (segment.hitTest(x, y)) return true;
    }
    return false;
  }

}
