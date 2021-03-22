import 'package:flutter/foundation.dart';

/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  return runApp(GaugeApp());
}

/// Represents the GaugeApp class
class GaugeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Range Slider ',
      home: Scaffold(body: MyHomePage()),
    );
  }
}

/// Represents MyHomePage class
class MyHomePage extends StatefulWidget {
  /// Creates the instance of MyHomePage

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _firstMarkerValue = 10;
  double _secondMarkerValue = 20;
  String _annotationValue = 'Slow';
  @override
  Widget build(BuildContext context) {
    return _getRadialRangeSlider();
  }

  /// Update the new thumb value to the range.
  void _handleFirstPointerValueChanged(double value) {
    if (value < _secondMarkerValue) {
      setState(() {
        _firstMarkerValue = value;
        _updateSpeed();
      });
    }
  }

  /// Cancel the dragging when pointer value reaching the axis end/start value, greater/less than another
  /// pointer value
  void _handleFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value < _secondMarkerValue) {
      _firstMarkerValue = args.value;
    } else {
      args.cancel = true;
    }
  }

  /// Cancel the dragging when pointer value reaching the axis end/start value, greater/less than another
  /// pointer value
  void _handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (_firstMarkerValue < args.value) {
      _secondMarkerValue = args.value;
    } else {
      args.cancel = true;
    }
  }

  /// Update the new thumb value to the range.
  void _handleSecondPointerValueChanged(double value) {
    if (_firstMarkerValue < value) {
      setState(() {
        _secondMarkerValue = value;
        _updateSpeed();
      });
    }
  }

  ///Update the annotation for pressure status
  void _updateSpeed() {
    if (_firstMarkerValue < _secondMarkerValue) {
      if (_firstMarkerValue > 1 && _firstMarkerValue < 40) {
        if (_secondMarkerValue < 40 && _secondMarkerValue > 1) {
          _annotationValue = 'Slow';
        }
      } else if (_firstMarkerValue > 40 && _firstMarkerValue < 60) {
        if (_secondMarkerValue < 60 && _secondMarkerValue > 40) {
          _annotationValue = 'Safe';
        }
      } else {
        _annotationValue = 'High';
      }
    }
  }

  /// Returns the radial range slider gauge
  Widget _getRadialRangeSlider() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          //Sets the minimum range for the slider
          minimum: 0,

          //Sets the maximum range for the slider
          maximum: 100,

          //Sets the major interval range
          interval: 10,

          //Sets the minor interval range
          minorTicksPerInterval: 10,

          //Sets the start angle
          startAngle: 250,

          //Sets the end angle
          endAngle: 250,

          //Update the marker pointer for thumb
          pointers: <GaugePointer>[
            //First thumb
            MarkerPointer(
              value: _firstMarkerValue, // We declared this in state class
              enableDragging: true,
              borderColor: Colors.green,
              borderWidth: 5,
              color: Colors.white,
              markerHeight: 25,
              markerWidth: 25,
              markerType: MarkerType.circle,
              onValueChanged: _handleFirstPointerValueChanged,
              onValueChanging: _handleFirstPointerValueChanging,
            ),

            //Second thumb
            MarkerPointer(
              value: _secondMarkerValue, // We declared this in state class
              color: Colors.white,
              enableDragging: true,
              borderColor: Colors.orange,
              markerHeight: 25,
              borderWidth: 5,
              markerWidth: 25,
              markerType: MarkerType.circle,
              onValueChanged: _handleSecondPointerValueChanged,
              onValueChanging: _handleSecondPointerValueChanging,
            ),
          ],

          //Add the track color between thumbs
          ranges: <GaugeRange>[
            GaugeRange(
                endValue: _secondMarkerValue, // We declared this in state class
                sizeUnit: GaugeSizeUnit.factor,
                startValue: _firstMarkerValue,
                startWidth: 0.06,
                endWidth: 0.06)
          ],

          //Update the pressure status
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '$_annotationValue', // We declared this in state class
                      style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Times',
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent),
                    ),
                  ],
                ),
                positionFactor: 0.1,
                angle: 0)
          ],
        )
      ],
    );
  }
}
