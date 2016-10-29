import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'src/screen_main.dart';

void main() {
  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  ScreenMain screenMain = new ScreenMain();
  stage.addChild(screenMain);
}
