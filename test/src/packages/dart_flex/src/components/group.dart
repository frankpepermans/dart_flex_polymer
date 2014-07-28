library dart_flex.components.group.dart;

import 'dart:async';
import 'dart:core';

import 'package:polymer/polymer.dart';

import 'package:dart_flex/dart_flex.dart';
import 'package:dart_flex/src/components/ui_wrapper.dart';

@CustomTag('flex-group')
class Group extends UIWrapper {

  //---------------------------------
  //
  // Private properties
  //
  //---------------------------------

  bool _isScrollPolicyInvalid = false;

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------

  //---------------------------------
  // horizontalScrollPolicy
  //---------------------------------

  static const EventHook<FrameworkEvent> onHorizontalScrollPolicyChangedEvent = const EventHook<FrameworkEvent>('horizontalScrollPolicyChanged');
  Stream<FrameworkEvent> get onHorizontalScrollPolicyChanged => Group.onHorizontalScrollPolicyChangedEvent.forTarget(this);
  String _horizontalScrollPolicy = ScrollPolicy.NONE;

  String get horizontalScrollPolicy => _horizontalScrollPolicy;
  set horizontalScrollPolicy(String value) {
    if (value != _horizontalScrollPolicy) {
      _horizontalScrollPolicy = value;

      _isScrollPolicyInvalid = true;

      notify(
        new FrameworkEvent(
          "horizontalScrollPolicyChanged"
        )
      );

      invalidateProperties();
    }
  }

  //---------------------------------
  // verticalScrollPolicy
  //---------------------------------

  static const EventHook<FrameworkEvent> onVerticalScrollPolicyChangedEvent = const EventHook<FrameworkEvent>('verticalScrollPolicyChanged');
  Stream<FrameworkEvent> get onVerticalScrollPolicyChanged => Group.onVerticalScrollPolicyChangedEvent.forTarget(this);
  String _verticalScrollPolicy = ScrollPolicy.NONE;

  String get verticalScrollPolicy => _verticalScrollPolicy;
  set verticalScrollPolicy(String value) {
    if (value != _verticalScrollPolicy) {
      _verticalScrollPolicy = value;

      _isScrollPolicyInvalid = true;

      notify(
        new FrameworkEvent(
          "verticalScrollPolicyChanged"
        )
      );

      invalidateProperties();
    }
  }

  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------

  Group.created() : super.created() {
  	className = 'Group';
  }

  //---------------------------------
  //
  // Public methods
  //
  //---------------------------------
  
  @override
  void attached() {
    super.attached();
    
    _isScrollPolicyInvalid = true;
  }
  
  @override
  void commitProperties() {
    super.commitProperties();

    if (control != null) {
      if (_isScrollPolicyInvalid) {
        _isScrollPolicyInvalid = false;

        _updateScrollPolicy();
      }
    }
  }

  //---------------------------------
  //
  // Protected methods
  //
  //---------------------------------

  void _updateScrollPolicy() {
    if (_horizontalScrollPolicy == ScrollPolicy.NONE) {
      reflowManager.invalidateCSS(control, 'overflow-x', 'hidden');
    } else if (_horizontalScrollPolicy == ScrollPolicy.AUTO) {
      reflowManager.invalidateCSS(control, 'overflow-x', 'auto');
    } else if (_horizontalScrollPolicy == ScrollPolicy.ON) {
      reflowManager.invalidateCSS(control, 'overflow-x', 'scroll');
    } else if (_horizontalScrollPolicy == ScrollPolicy.DISABLED) {
      reflowManager.invalidateCSS(control, 'overflow-x', 'visible');
    }

    if (_verticalScrollPolicy == ScrollPolicy.NONE) {
      reflowManager.invalidateCSS(control, 'overflow-y', 'hidden');
    } else if (_verticalScrollPolicy == ScrollPolicy.AUTO) {
      reflowManager.invalidateCSS(control, 'overflow-y', 'auto');
    } else if (_verticalScrollPolicy == ScrollPolicy.ON) {
      reflowManager.invalidateCSS(control, 'overflow-y', 'scroll');
    } else if (_verticalScrollPolicy == ScrollPolicy.DISABLED) {
      reflowManager.invalidateCSS(control, 'overflow-y', 'visible');
    }
  }
}

