library dart_flex.components.button.dart;

import 'dart:async';
import 'dart:core';
import 'dart:html';

import 'package:polymer/polymer.dart';

import 'package:dart_flex/dart_flex.dart';
import 'package:dart_flex/src/components/ui_wrapper.dart';

@CustomTag('flex-button')
class Button extends UIWrapper {

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  bool _allowClick = true;
  
  static const EventHook<FrameworkEvent> onButtonClickEvent = const EventHook<FrameworkEvent>('buttonClick');
  Stream<FrameworkEvent> get onButtonClick => Button.onButtonClickEvent.forTarget(this);

  //---------------------------------
  // label
  //---------------------------------

  static const EventHook<FrameworkEvent> onLabelChangedEvent = const EventHook<FrameworkEvent>('labelChanged');
  Stream<FrameworkEvent> get onLabelChanged => Button.onLabelChangedEvent.forTarget(this);
  String _label;
  
  @published String get label => _label;
  @published set label(String value) {
    if (value != _label) {
      _label = value;

      notify(
        new FrameworkEvent(
          'labelChanged'
        )
      );

      _commitLabel();
    }
  }

  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------

  Button.created() : super.created() {
    className = 'Button';
  }

  //---------------------------------
  //
  // Public methods
  //
  //---------------------------------
  
  @override
  void attached() {
    super.attached();
    
    streamSubscriptionManager.add(
        'button_elementClick', 
        control.onClick.listen(_propagateClick)
    );
    
    streamSubscriptionManager.add(
        'button_elementClick', 
        control.onTouchLeave.listen(_propagateClick)
    );
  }
  
  //---------------------------------
  //
  // Protected methods
  //
  //---------------------------------

  void _commitLabel() {
    if (control != null) {
      reflowManager.scheduleMethod(this, _updateElementText, [_label]);
    } else {
      later > _commitLabel;
    }
  }
  
  void _updateElementText(String label) => control.setInnerHtml(label);
  
  void _propagateClick(Event event) {
    if (_allowClick) {
      _allowClick = false;
      
      notify(
          new FrameworkEvent(
              'buttonClick'
          )
      );
      
      new Timer(
        const Duration(milliseconds: 50),
        () => _allowClick = true
      );
    }
  }
}