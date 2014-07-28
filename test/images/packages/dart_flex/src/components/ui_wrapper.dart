library dart_flex.components.ui_wrapper.dart;

import 'dart:async';
import 'dart:core';
import 'dart:html';
import 'dart:html_common';
import 'dart:math';

import 'package:polymer/polymer.dart';

import 'package:dart_flex/dart_flex.dart';

class UIWrapper extends PolymerElement with FlexLayoutMixin, CallLaterMixin, FrameworkEventDispatcherMixin implements IUIWrapper {
  
  //---------------------------------
  //
  // Protected properties
  //
  //---------------------------------

  bool _isLayoutUpdateRequired = false;
  
  int getPageItemSize() => 0;
  int getPageOffset() => 0;
  int getPageSize() => 0;

  //---------------------------------
  //
  // Public properties
  //
  //---------------------------------
  
  static const EventHook<FrameworkEvent> onInitializationCompleteEvent = const EventHook<FrameworkEvent>('initializationComplete');
  Stream<FrameworkEvent> get onInitializationComplete => UIWrapper.onInitializationCompleteEvent.forTarget(this);
  
  static const EventHook<FrameworkEvent<IUIWrapper>> onSkinPartAddedEvent = const EventHook<FrameworkEvent<IUIWrapper>>('skinPartAdded');
  Stream<FrameworkEvent<IUIWrapper>> get onSkinPartAdded => UIWrapper.onSkinPartAddedEvent.forTarget(this);

  //---------------------------------
  // reflowManager
  //---------------------------------

  ReflowManager _reflowManager;

  ReflowManager get reflowManager => _reflowManager;
  
  //---------------------------------
  // streamSubscriptionManager
  //---------------------------------

  StreamSubscriptionManager _streamSubscriptionManager = new StreamSubscriptionManager();

  StreamSubscriptionManager get streamSubscriptionManager => _streamSubscriptionManager;
  
  //---------------------------------
  // stylePrefix
  //---------------------------------

  static const EventHook<FrameworkEvent> onStylePrefixChangedEvent = const EventHook<FrameworkEvent>('stylePrefixChanged');
  Stream<FrameworkEvent> get onStylePrefixChanged => UIWrapper.onStylePrefixChangedEvent.forTarget(this);
  String _stylePrefix;
  bool _isStylePrefixChanged = false;

  String get stylePrefix => _stylePrefix;

  set stylePrefix(String value) {
    if (value != _stylePrefix) {
      _stylePrefix = value;

      notify(
        new FrameworkEvent('stylePrefixChanged')
      );

      invalidateProperties();
    }
  }
  
  //---------------------------------
  // useMatrixTransformations
  //---------------------------------
  
  bool _useMatrixTransformations = false;
  
  bool get useMatrixTransformations => _useMatrixTransformations;
  set useMatrixTransformations(bool value) {
    final bool newValue = (window.css.supports('${Device.cssPrefix}transform', 'matrix3d(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)')) ? value : false;
    
    if (newValue != _useMatrixTransformations) {
      _useMatrixTransformations = newValue;
      
      updateControl(1);
      updateControl(2);
    }
  }
  
  //---------------------------------
  // enabled
  //---------------------------------
  
  bool _enabled = true;
  bool _isEnabledChanged = false;
  
  bool get enabled => _enabled;
  set enabled(bool value) {
    if (value != _enabled) {
      _enabled = value;
      _isEnabledChanged = true;
      
      invalidateProperties();
    }
  }
  
  //---------------------------------
  // disableRemoveComponents
  //---------------------------------
  
  bool _disableRemoveComponents = false;
  
  bool get disableRemoveComponents => _disableRemoveComponents;
  set disableRemoveComponents(bool value) {
    if (value != _disableRemoveComponents) {
      _disableRemoveComponents = value;
    }
  }
  
  //---------------------------------
  // classes
  //---------------------------------

  static const EventHook<FrameworkEvent> onCSSClassesChangedEvent = const EventHook<FrameworkEvent>('cssClassesChanged');
  Stream<FrameworkEvent> get onCSSClassesChanged => UIWrapper.onCSSClassesChangedEvent.forTarget(this);
  List<String> _cssClasses = <String>[];
  bool _isCSSClassesChanged = false;

  List<String> get cssClasses => _cssClasses;

  set cssClasses(List<String> value) {
    if (value != _cssClasses) {
      _cssClasses = value;

      notify(
        new FrameworkEvent('cssClassesChanged')
      );

      refreshStyle();
    }
  }
  
  void refreshStyle() {
    _isCSSClassesChanged = true;

    invalidateProperties();
  }

  //---------------------------------
  // visible
  //---------------------------------
  
  static const EventHook<FrameworkEvent> onVisibleChangedEvent = const EventHook<FrameworkEvent>('visibleChanged');
  Stream<FrameworkEvent> get onVisibleChanged => UIWrapper.onVisibleChangedEvent.forTarget(this);
  bool _visible = true;

  bool get visible => _visible;

  set visible(bool value) {
    if (value != _visible) {
      _visible = value;

      notify(
        new FrameworkEvent('visibleChanged')
      );

      later > updateVisibility;
    }
  }
  
  //---------------------------------
  // inheritsDefaultCSS
  //---------------------------------

  static const EventHook<FrameworkEvent> onInheritsDefaultCSSChangedEvent = const EventHook<FrameworkEvent>('inheritsDefaultCSSChanged');
  Stream<FrameworkEvent> get onInheritsDefaultCSSChanged => UIWrapper.onInheritsDefaultCSSChangedEvent.forTarget(this);
  bool _inheritsDefaultCSS = true;

  bool get inheritsDefaultCSS => _inheritsDefaultCSS;
  set inheritsDefaultCSS(bool value) {
    if (value != _inheritsDefaultCSS) {
      _inheritsDefaultCSS = value;
      
      if (_isInitialized) {
        later > updateDefaultClass;
      }

      notify(
        new FrameworkEvent('inheritsDefaultCSSChanged')
      );
    }
  }

  //---------------------------------
  // addLaterElements
  //---------------------------------

  List<IUIWrapper> _addLaterElements = <IUIWrapper>[];

  //---------------------------------
  // isInitialized
  //---------------------------------

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //---------------------------------
  // owner
  //---------------------------------

  static const EventHook<FrameworkEvent> onOwnerChangedEvent = const EventHook<FrameworkEvent>('ownerChanged');
  Stream<FrameworkEvent> get onOwnerChanged => UIWrapper.onOwnerChangedEvent.forTarget(this);
  IUIWrapper _owner;

  IUIWrapper get owner => _owner;

  //---------------------------------
  // childWrappers
  //---------------------------------

  List<IUIWrapper> _childWrappers = <IUIWrapper>[];

  List<IUIWrapper> get childWrappers => _childWrappers;
  
  void clearChildWrappers() => _childWrappers.clear();
  
  //---------------------------------
  // className
  //---------------------------------

  static const EventHook<FrameworkEvent> onClassNameChangedEvent = const EventHook<FrameworkEvent>('classNameChanged');
  Stream<FrameworkEvent> get onClassNameChanged => UIWrapper.onClassNameChangedEvent.forTarget(this);
  String _className = 'UIWrapper';

  String get className => _className;
  set className(String value) {
    if (value != _className) {
      _className = value;
      
      if (_isInitialized) later > updateDefaultClass;

      notify(
        new FrameworkEvent('classNameChanged')
      );
    }
  }

  //---------------------------------
  // control
  //---------------------------------

  static const EventHook<FrameworkEvent<Element>> onControlChangedEvent = const EventHook<FrameworkEvent<Element>>('controlChanged');
  Stream<FrameworkEvent<Element>> get onControlChanged => UIWrapper.onControlChangedEvent.forTarget(this);
  Element _control;

  Element get control => _control;

  //---------------------------------
  //
  // Constructor
  //
  //---------------------------------

  UIWrapper.created() : super.created();
  
  @override
  void prepareElement() {
    updateManager = new UpdateManager(this);
        
    eventDispatcher = new FrameworkEventDispatcher(dispatcher: this);
    
    super.prepareElement();
  }

  //---------------------------------
  //
  // Operator overloads
  //
  //---------------------------------

  void operator []=(String type, Function eventHandler) => observeEventType(type, eventHandler);
  
  @override
  noSuchMethod(Invocation invocation) => null;

  //---------------------------------
  //
  // Public methods
  //
  //---------------------------------
  
  @override
  void attached() {
    super.attached();
    
    _reflowManager = new ReflowManager();
    
    final Element ctr = shadowRoot.querySelector('#control');
    
    _setControl((ctr == null) ? this : ctr);
    
    if (parent is IUIWrapper) (parent as IUIWrapper).addComponent(this);
    
    _streamSubscriptionManager.add('windowResize', window.onResize.listen(invalidateSize), flushExisting: true);
    
    notify(
        new FrameworkEvent<Element>(
            'controlChanged',
            relatedObject: _control
        )
    );
    
    initialize();
    
    later > updateSize;
  }
  
  void preInitialize(IUIWrapper forOwner) {
    _reflowManager = new ReflowManager();
    _owner = forOwner;
    
    notify(
        new FrameworkEvent<IUIWrapper>(
            'ownerChanged',
            relatedObject: forOwner
        )
    );
    
    initialize();
  }
  
  void invalidateLayout() {
    _isLayoutUpdateRequired = allowLayoutUpdate;

    later > commitProperties;
  }

  void invalidateProperties() {
    if (!_isLayoutUpdateRequired) invalidateLayout();
  }
  
  void invalidateSize(Event event) => later > updateSize;
  
  void initialize() {
    if (!_isInitialized) {
      _isInitialized = true;
      
      createChildren();
      
      if (_control != null) later > updateVisibility;
      
      notify(
          new FrameworkEvent(
              'initializationComplete'
          )
      );

      invalidateProperties();
    }
  }
  
  void invalidateOwnerProperties() {
    if (_owner != null) _owner.invalidateProperties();
  }

  void createChildren() {}
  
  void commitProperties() {
    if (_isCSSClassesChanged) {
      _isCSSClassesChanged = false;
      
      if (_control != null) updateDefaultClass();
    }
    
    if (_isEnabledChanged) {
      _isEnabledChanged = false;
      
      updateEnabledStatus();
    }
    
    if (_isLayoutUpdateRequired) {
      _isLayoutUpdateRequired = false;

      updateLayout();
    }
  }

  void addComponent(IUIWrapper element, {bool prepend: false}) {
    if (_childWrappers.indexOf(element) >= 0) return;
    
    final UIWrapper elementCast = element as UIWrapper;

    elementCast._owner = this;
          
    elementCast.notify(
        new FrameworkEvent<IUIWrapper>(
            'ownerChanged',
            relatedObject: this
        )
    );
    
    if (
        (_stylePrefix != null) &&
        (elementCast._stylePrefix == null)
    ) elementCast._stylePrefix = _stylePrefix;
    
    elementCast.initialize();

    invalidateLayout();
    
    _childWrappers.add(element);
    
    control.append(element);
  }

  void removeComponent(IUIWrapper element, {bool flush: true}) {
    if (_disableRemoveComponents) return;
    
    if (
        (_control != null) &&
        (element != null) &&
        (element.control != null) &&
        _control.contains(element.control)
    ) _control.children.remove(element.control);
    
    _childWrappers.remove(element);
    _addLaterElements.remove(element);
    
    if (flush) {
      element.flushHandler();
      
      element.removeAll();
    }
    
    invalidateLayout();
  }

  void removeAll() {
    if (_disableRemoveComponents) return;
    
    int i = _childWrappers.length;
    
    while (i > 0) removeComponent(_childWrappers[--i]);
    
    _childWrappers = <IUIWrapper>[];
  }
  
  void flushHandler() => _streamSubscriptionManager.flushAll();
  
  void forceInvalidateSize() => invalidateSize(null);
  
  void updateLayout() {
    if ( 
      allowLayoutUpdate &&
      (width > 0) &&
      (height > 0)
    ) {
      if (layout != null) layout.doLayout(
          width,
          height,
          getPageItemSize(),
          getPageOffset(),
          getPageSize(),
          _childWrappers
      );
      else _childWrappers.forEach(
          (IFlexLayout element) {
            element.x = element.paddingLeft;
            element.y = element.paddingRight;
            element.width = width - element.paddingLeft - element.paddingRight;
            element.height = height - element.paddingTop - element.paddingBottom;
          }
      );
    }
  }
  
  void updateSize() {
    if (_control != null) {
      Element parentElement = _control;
      
      while (parentElement != null) {
        if (
            (
              (parentElement.attributes.containsKey('aria-hidden')) &&
              (parentElement.attributes['aria-hidden'] == 'true') 
            ) ||
            (parentElement.style.display == 'none')
        ) {
          reflowManager.invocationFrame.whenComplete(updateSize);
          
          return;
        }
          
        parentElement = parentElement.parent;
      }
      
      final Rectangle rect = _control.client;
      
      if (
          (rect.width == 0) && 
          (rect.height == 0)
      ) reflowManager.invocationFrame.whenComplete(updateSize);
      else {
        width = rect.width;
        height = rect.height;
      }
    } else width = height = 0;
  }

  void updateVisibility() {
    if (
        (_control != null) &&
        (_reflowManager != null)
    ) {
      _control.hidden = !_visible;
      
      if (_control.style.display == 'none') _reflowManager.invalidateCSS(_control, 'display', (_visible ? 'block' : 'none'));
      
      _reflowManager.invalidateCSS(_control, 'visibility', (_visible ? 'visible' : 'hidden'));
    }
  }
  
  void updateEnabledStatus() {
    if (_control != null) reflowManager.invalidateCSS(_control, 'pointer-events', (_enabled ? 'auto' : 'none'));
  }
  
  void updateControl(int type) {
    if (
        (_control != null)
    ) {
      final Function I = _reflowManager.invalidateCSS;
      if (_useMatrixTransformations) {
        switch (type) {
          case 1 : case 2 : I(_control, '${Device.cssPrefix}transform', 'matrix3d(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, ${x}, ${y}, 0, 1)');  break;
          case 3 : I(_control, 'width', ((width == 0) ? 'auto' : (width.toString() + 'px')));    break;
          case 4 : I(_control, 'height', ((height == 0) ? 'auto' : (height.toString() + 'px'))); break;
          case 5 :
            _reflowManager.batchInvalidateCSS(
                _control,
                [
                  '${Device.cssPrefix}transform', 'matrix3d(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, ${x}, ${y}, 0, 1)',
                  'width', ((width == 0) ? 'auto' : (width.toString() + 'px')),
                  'height', ((height == 0) ? 'auto' : (height.toString() + 'px'))
                ]
            );
            
            break;
        }
      } else {
        switch (type) {
          case 1 : I(_control, 'left', (x.toString() + 'px'));                                    break;
          case 2 : I(_control, 'top', (y.toString() + 'px'));                                     break;
          case 3 : I(_control, 'width', ((width == 0) ? 'auto' : (width.toString() + 'px')));    break;
          case 4 : I(_control, 'height', ((height == 0) ? 'auto' : (height.toString() + 'px'))); break;
          case 5 :
            _reflowManager.batchInvalidateCSS(
                _control,
                [
                  'left', (x.toString() + 'px'),
                  'top', (y.toString() + 'px'),
                  'width', ((width == 0) ? 'auto' : (width.toString() + 'px')),
                  'height', ((height == 0) ? 'auto' : (height.toString() + 'px'))
                ]
            );

            break;
        }
      }
    }
  }
  
  void transportComponents(IUIWrapper target) {
    if (_childWrappers != null) {
      final List<IUIWrapper> list = <IUIWrapper>[];
      IUIWrapper element;
      int i = _childWrappers.length;
      
      _disableRemoveComponents = false;
      
      while (i > 0) {
        element = _childWrappers[--i];
        
        removeComponent(element, flush: false);
        
        list.insert(0, element);
      }
      
      list.forEach(
        (IUIWrapper wrapper) => target.addComponent(wrapper) 
      );
    }
  }

  //---------------------------------
  //
  // Protected methods
  //
  //---------------------------------

  void _setControl(Element element) {
    _control = element;
    
    _control.style.visibility = 'none';
    
    if (_inheritsDefaultCSS) _reflowManager.scheduleMethod(this, _addDefaultClass, [], forceSingleExecution: true);
    
    if (_cssClasses != null) _reflowManager.scheduleMethod(this, _addAllPendingClasses, [], forceSingleExecution: true);

    updateControl(5);

    notify(
      new FrameworkEvent<Element>(
          'controlChanged',
          relatedObject: element
      )
    );

    invalidateProperties();
    
    _addAllPendingElements();
  }
  
  void updateDefaultClass() {
    if (_control == null) return;
    
    final List<String> newClasses = <String>[];
    final List<String> cssList = '_${_className}'.split(' ');
    
    cssList.forEach(
      (String C) {
        if (_inheritsDefaultCSS) newClasses.add(C);
      }
    );
    
    if (_cssClasses != null) newClasses.addAll(_cssClasses);
    
    _control.classes.clear();
    _control.classes.addAll(newClasses);
  }
  
  bool _addDefaultClass() => _control.classes.add('_$_className');
  
  void _addAllPendingClasses() => _control.classes.addAll(_cssClasses);

  void _addAllPendingElements() {
    final List<IUIWrapper> listClone = new List<IUIWrapper>.from(_addLaterElements, growable:false);
    
    _addLaterElements = <IUIWrapper>[];
    
    listClone.forEach(
        (IUIWrapper element) => addComponent(element)
    );
  }
}