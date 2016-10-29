part of stagexl.engine;

class RenderContextCanvas extends RenderContext {

  final CanvasElement _canvasElement;
  final CanvasRenderingContext2D _renderingContext;

  Matrix _identityMatrix = new Matrix.fromIdentity();
  BlendMode _activeBlendMode = BlendMode.NORMAL;
  double _activeAlpha = 1.0;

  RenderContextCanvas(CanvasElement canvasElement) :
    _canvasElement = canvasElement,
    _renderingContext = canvasElement.context2D {

    this.reset();
  }

  //---------------------------------------------------------------------------

  CanvasRenderingContext2D get rawContext => _renderingContext;
  RenderEngine get renderEngine => RenderEngine.Canvas2D;

  //---------------------------------------------------------------------------

  void reset() {
    setTransform(_identityMatrix);
    setBlendMode(BlendMode.NORMAL);
    setAlpha(1.0);
  }

  void clear(int color) {

    setTransform(_identityMatrix);
    setBlendMode(BlendMode.NORMAL);
    setAlpha(1.0);

    int alpha = colorGetA(color);

    if (alpha < 255) {
      _renderingContext.clearRect(0, 0, _canvasElement.width, _canvasElement.height);
    }

    if (alpha > 0) {
      _renderingContext.fillStyle = color2rgba(color);
      _renderingContext.fillRect(0, 0, _canvasElement.width, _canvasElement.height);
    }
  }

  void flush() {

  }

  //---------------------------------------------------------------------------

  void beginRenderMask(RenderState renderState, RenderMask mask) {
    var matrix = renderState.globalMatrix;
    _renderingContext.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
    _renderingContext.beginPath();
    mask.renderMask(renderState);
    _renderingContext.save();
    _renderingContext.clip();
  }

  void endRenderMask(RenderState renderState, RenderMask mask) {
    _renderingContext.restore();
    _renderingContext.globalAlpha = _activeAlpha;
    _renderingContext.globalCompositeOperation = _activeBlendMode.compositeOperation;
    if (mask.border) {
      _renderingContext.strokeStyle = color2rgba(mask.borderColor);
      _renderingContext.lineWidth = mask.borderWidth;
      _renderingContext.lineCap = "round";
      _renderingContext.lineJoin = "round";
      _renderingContext.stroke();
    }
  }

  //---------------------------------------------------------------------------

  void renderTextureQuad(
      RenderState renderState,
      RenderTextureQuad renderTextureQuad) {

    if (renderTextureQuad.hasCustomVertices) {
      var renderTexture = renderTextureQuad.renderTexture;
      var ixList = renderTextureQuad.ixList;
      var vxList = renderTextureQuad.vxList;
      this.renderTextureMesh(renderState, renderTexture, ixList, vxList);
      return;
    }

    var context = _renderingContext;
    var source = renderTextureQuad.renderTexture.source;
    var rotation = renderTextureQuad.rotation;
    var sourceRect = renderTextureQuad.sourceRectangle;
    var vxList = renderTextureQuad.vxListQuad;
    var matrix = renderState.globalMatrix;
    var alpha = renderState.globalAlpha;
    var blendMode = renderState.globalBlendMode;

    if (_activeAlpha != alpha) {
      _activeAlpha = alpha;
      context.globalAlpha = alpha;
    }

    if (_activeBlendMode != blendMode) {
      _activeBlendMode = blendMode;
      context.globalCompositeOperation = blendMode.compositeOperation;
    }

    if (rotation == 0) {

      context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
      context.drawImageScaledFromSource(source,
          sourceRect.left, sourceRect.top, sourceRect.width, sourceRect.height,
          vxList[0], vxList[1], vxList[8] - vxList[0], vxList[9] - vxList[1]);

    } else if (rotation == 1) {

      context.setTransform(-matrix.c, -matrix.d, matrix.a, matrix.b, matrix.tx, matrix.ty);
      context.drawImageScaledFromSource(source,
          sourceRect.left, sourceRect.top, sourceRect.width, sourceRect.height,
          0.0 - vxList[13], vxList[12], vxList[9] - vxList[1], vxList[8] - vxList[0]);

    } else if (rotation == 2) {

      context.setTransform(-matrix.a, -matrix.b, -matrix.c, -matrix.d, matrix.tx, matrix.ty);
      context.drawImageScaledFromSource(source,
          sourceRect.left, sourceRect.top, sourceRect.width, sourceRect.height,
          0.0 - vxList[8], 0.0 - vxList[9], vxList[8] - vxList[0], vxList[9] - vxList[1]);

    } else if (rotation == 3) {

      context.setTransform(matrix.c, matrix.d, -matrix.a, -matrix.b, matrix.tx, matrix.ty);
      context.drawImageScaledFromSource(source,
          sourceRect.left, sourceRect.top, sourceRect.width, sourceRect.height,
          vxList[5], 0.0 - vxList[4], vxList[9] - vxList[1], vxList[8] - vxList[0]);
    }
  }

  //---------------------------------------------------------------------------

  void renderTextureMesh(
      RenderState renderState, RenderTexture renderTexture,
      Int16List ixList, Float32List vxList) {

    var context = _renderingContext;
    var source = renderTexture.source;
    var sourceWidth = renderTexture.width;
    var sourceHeight = renderTexture.height;
    var matrix = renderState.globalMatrix;
    var alpha = renderState.globalAlpha;
    var blendMode = renderState.globalBlendMode;

    if (_activeAlpha != alpha) {
      _activeAlpha = alpha;
      context.globalAlpha = alpha;
    }

    if (_activeBlendMode != blendMode) {
      _activeBlendMode = blendMode;
      context.globalCompositeOperation = blendMode.compositeOperation;
    }

    context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);

    for(int i = 0; i < ixList.length - 2; i += 3) {

      int i1 = ixList[i + 0] << 2;
      num x1 = vxList[i1 + 0];
      num y1 = vxList[i1 + 1];
      num u1 = vxList[i1 + 2] * sourceWidth;
      num v1 = vxList[i1 + 3] * sourceHeight;

      int i2 = ixList[i + 1] << 2;
      num x2 = vxList[i2 + 0];
      num y2 = vxList[i2 + 1];
      num u2 = vxList[i2 + 2] * sourceWidth;
      num v2 = vxList[i2 + 3] * sourceHeight;

      int i3 = ixList[i + 2] << 2;
      num x3 = vxList[i3 + 0];
      num y3 = vxList[i3 + 1];
      num u3 = vxList[i3 + 2] * sourceWidth;
      num v3 = vxList[i3 + 3] * sourceHeight;

      num mm = v1 * (u3 - u2) + v2 * (u1 - u3) + v3 * (u2 - u1);
      num ma = x1 * (v2 - v3) + x2 * (v3 - v1) + x3 * (v1 - v2);
      num mb = y1 * (v2 - v3) + y2 * (v3 - v1) + y3 * (v1 - v2);
      num mc = x1 * (u3 - u2) + x2 * (u1 - u3) + x3 * (u2 - u1);
      num md = y1 * (u3 - u2) + y2 * (u1 - u3) + y3 * (u2 - u1);
      num mx = x1 * (v3 * u2 - v2 * u3) + x2 * (v1 * u3 - v3 * u1) + x3 * (v2 * u1 - v1 * u2);
      num my = y1 * (v3 * u2 - v2 * u3) + y2 * (v1 * u3 - v3 * u1) + y3 * (v2 * u1 - v1 * u2);

      context.save();
      context.beginPath();
      context.moveTo(x1, y1);
      context.lineTo(x2, y2);
      context.lineTo(x3, y3);
      context.clip();
      context.transform(ma / mm, mb / mm, mc / mm, md / mm, mx / mm, my / mm);
      context.drawImage(source, 0, 0);
      context.restore();
    }
  }

  //---------------------------------------------------------------------------

  void renderTriangle(
      RenderState renderState,
      num x1, num y1, num x2, num y2, num x3, num y3, int color) {

    var context = _renderingContext;
    var matrix = renderState.globalMatrix;
    var alpha = renderState.globalAlpha;
    var blendMode = renderState.globalBlendMode;

    if (_activeAlpha != alpha) {
      _activeAlpha = alpha;
      context.globalAlpha = alpha;
    }

    if (_activeBlendMode != blendMode) {
      _activeBlendMode = blendMode;
      context.globalCompositeOperation = blendMode.compositeOperation;
    }

    context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);

    context.beginPath();
    context.moveTo(x1, y1);
    context.lineTo(x2, y2);
    context.lineTo(x3, y3);
    context.closePath();
    context.fillStyle = color2rgba(color);
    context.fill();
  }

  //---------------------------------------------------------------------------

  void renderTriangleMesh(
      RenderState renderState,
      Int16List ixList, Float32List vxList, int color) {

    var context = _renderingContext;
    var matrix = renderState.globalMatrix;
    var alpha = renderState.globalAlpha;
    var blendMode = renderState.globalBlendMode;

    if (_activeAlpha != alpha) {
      _activeAlpha = alpha;
      context.globalAlpha = alpha;
    }

    if (_activeBlendMode != blendMode) {
      _activeBlendMode = blendMode;
      context.globalCompositeOperation = blendMode.compositeOperation;
    }

    context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
    context.beginPath();

    for(int i = 0; i < ixList.length - 2; i += 3) {
      int i0 = ixList[i + 0] << 1;
      int i1 = ixList[i + 1] << 1;
      int i2 = ixList[i + 2] << 1;
      num x1 = vxList[i0 + 0];
      num y1 = vxList[i0 + 1];
      num x2 = vxList[i1 + 0];
      num y2 = vxList[i1 + 1];
      num x3 = vxList[i2 + 0];
      num y3 = vxList[i2 + 1];
      context.moveTo(x1, y1);
      context.lineTo(x2, y2);
      context.lineTo(x3, y3);
    }

    context.fillStyle = color2rgba(color);
    context.fill();
  }

  //---------------------------------------------------------------------------

  void renderTextureQuadFiltered(
      RenderState renderState, RenderTextureQuad renderTextureQuad,
      List<RenderFilter> renderFilters) {

    // It would be to slow to render filters in real time using the
    // Canvas2D context. This is only feasible with the WebGL context.

    this.renderTextureQuad(renderState, renderTextureQuad);
  }

  //---------------------------------------------------------------------------

  void renderObjectFiltered(RenderState renderState, RenderObject renderObject) {

    // It would be to slow to render filters in real time using the
    // Canvas2D context. This is only feasible with the WebGL context.

    renderObject.render(renderState);
  }

  //---------------------------------------------------------------------------
  //---------------------------------------------------------------------------

  void setTransform(Matrix matrix) {
    _renderingContext.setTransform(
        matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
  }

  void setAlpha(num alpha) {
    _activeAlpha = alpha;
    _renderingContext.globalAlpha = alpha;
  }

  void setBlendMode(BlendMode blendMode) {
    _activeBlendMode = blendMode;
    _renderingContext.globalCompositeOperation = blendMode.compositeOperation;
  }

}
