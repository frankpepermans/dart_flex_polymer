library dart_flex.components.hgroup.dart;

import 'dart:async';
import 'dart:core';

import 'package:polymer/polymer.dart';

import 'package:dart_flex/dart_flex.dart';
import 'package:dart_flex/src/components/group.dart';

@CustomTag('flex-hgroup')
class HGroup extends Group {
  
  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------

  //---------------------------------
  // gap
  //---------------------------------
  
  static const EventHook<FrameworkEvent> onGapChangedEvent = const EventHook<FrameworkEvent>('gapChanged');
  Stream<FrameworkEvent> get onGapChanged => HGroup.onGapChangedEvent.forTarget(this);

  int get gap => layout.gap;
  
  set gap(int value) {
    if (value != layout.gap) {
      layout.gap = value;

      notify(
        new FrameworkEvent(
          "gapChanged"
        )
      );
    }
  }
  
  //---------------------------------
  // align
  //---------------------------------
  
  static const EventHook<FrameworkEvent> onAlignChangedEvent = const EventHook<FrameworkEvent>('alignChanged');
  Stream<FrameworkEvent> get onAlignChanged => HGroup.onAlignChangedEvent.forTarget(this);

  String get align => layout.align;
  
  set align(String value) {
    if (value != layout.align) {
      layout.align = value;

      notify(
        new FrameworkEvent(
          "alignChanged"
        )
      );
    }
  }

  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------

  HGroup.created() : super.created() {
  	className = 'HGroup';
	
    layout = new HorizontalLayout()..gap = 10;
  }

  //---------------------------------
  //
  // Public methods
  //
  //---------------------------------

}



