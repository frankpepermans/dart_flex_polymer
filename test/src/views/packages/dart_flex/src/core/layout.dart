part of dart_flex;

abstract class IFlexLayout {
  
  Stream<FrameworkEvent> get onXChanged;
  Stream<FrameworkEvent> get onYChanged;
  Stream<FrameworkEvent> get onWidthChanged;
  Stream<FrameworkEvent> get onPercentWidthChanged;
  Stream<FrameworkEvent> get onHeightChanged;
  Stream<FrameworkEvent> get onPercentHeightChanged;
  Stream<FrameworkEvent> get onPaddingLeftChanged;
  Stream<FrameworkEvent> get onPaddingRightChanged;
  Stream<FrameworkEvent> get onPaddingTopChanged;
  Stream<FrameworkEvent> get onPaddingBottomChanged;
  Stream<FrameworkEvent> get onLayoutChanged;
  
  bool get includeInLayout;
  set includeInLayout(bool value);
  
  bool get allowLayoutUpdate;
  set allowLayoutUpdate(bool value);

  bool get autoSize;
  set autoSize(bool value);
  
  int get x;
  set x(int value);

  int get y;
  set y(int value);

  int get width;
  set width(int value);

  double get percentWidth;
  set percentWidth(double value);

  int get height;
  set height(int value);

  double get percentHeight;
  set percentHeight(double value);

  int get paddingLeft;
  set paddingLeft(int value);

  int get paddingRight;
  set paddingRight(int value);

  int get paddingTop;
  set paddingTop(int value);

  int get paddingBottom;
  set paddingBottom(int value);
  
  ILayout get layout;
  set layout(ILayout value);
  
  void updateControl(int type);
  
}

abstract class FlexLayoutMixin implements ILifeCycle, IFrameworkEventDispatcher {
  
  //---------------------------------
  // includeInLayout
  //---------------------------------

  static const EventHook<FrameworkEvent> onIncludeInLayoutChangedEvent = const EventHook<FrameworkEvent>('includeInLayoutChanged');
  Stream<FrameworkEvent> get onIncludeInLayoutChanged => FlexLayoutMixin.onIncludeInLayoutChangedEvent.forTarget(this);
  bool _includeInLayout = true;

  @published bool get includeInLayout => _includeInLayout;

  @published set includeInLayout(bool value) {
    if (value != _includeInLayout) {
      _includeInLayout = value;

      notify(
        new FrameworkEvent('includeInLayoutChanged')
      );

      invalidateOwnerProperties();

      invalidateProperties();
    }
  }
  
  //---------------------------------
  // allowLayoutUpdate
  //---------------------------------

  static const EventHook<FrameworkEvent> onAllowLayoutUpdateChangedEvent = const EventHook<FrameworkEvent>('allowLayoutUpdateChanged');
  Stream<FrameworkEvent> get onAllowLayoutUpdateChanged => FlexLayoutMixin.onAllowLayoutUpdateChangedEvent.forTarget(this);
  bool _allowLayoutUpdate = true;

  @published bool get allowLayoutUpdate => _allowLayoutUpdate;

  @published set allowLayoutUpdate(bool value) {
    if (value != _allowLayoutUpdate) {
      _allowLayoutUpdate = value;

      notify(
        new FrameworkEvent('allowLayoutUpdateChanged')
      );

      invalidateOwnerProperties();

      invalidateProperties();
    }
  }

  //---------------------------------
  // autoSize
  //---------------------------------

  static const EventHook<FrameworkEvent> onAutoSizeChangedEvent = const EventHook<FrameworkEvent>('autoSizeChanged');
  Stream<FrameworkEvent> get onAutoSizeChanged => FlexLayoutMixin.onAutoSizeChangedEvent.forTarget(this);
  bool _autoSize = true;

  @published bool get autoSize => _autoSize;

  @published set autoSize(bool value) {
    if (value != _autoSize) {
      _autoSize = value;

      notify(
        new FrameworkEvent('autoSizeChanged')
      );

      invalidateOwnerProperties();

      invalidateProperties();
    }
  }
  
  //---------------------------------
  // x
  //---------------------------------
  
  static const EventHook<FrameworkEvent> onXChangedEvent = const EventHook<FrameworkEvent>('xChanged');
  Stream<FrameworkEvent> get onXChanged => FlexLayoutMixin.onXChangedEvent.forTarget(this);
  int _x = 0;

  @published int get x => _x;

  @published set x(int value) {
    if (value != _x) {
      _x = value;

      notify(
        new FrameworkEvent('xChanged')
      );

      updateControl(1);
    }
  }

  //---------------------------------
  // y
  //---------------------------------

  static const EventHook<FrameworkEvent> onYChangedEvent = const EventHook<FrameworkEvent>('yChanged');
  Stream<FrameworkEvent> get onYChanged => FlexLayoutMixin.onYChangedEvent.forTarget(this);
  int _y = 0;

  @published int get y => _y;

  @published set y(int value) {
    if (value != _y) {
      _y = value;

      notify(
        new FrameworkEvent('yChanged')
      );

      updateControl(2);
    }
  }

  //---------------------------------
  // width
  //---------------------------------

  static const EventHook<FrameworkEvent> onWidthChangedEvent = const EventHook<FrameworkEvent>('widthChanged');
  Stream<FrameworkEvent> get onWidthChanged => FlexLayoutMixin.onWidthChangedEvent.forTarget(this);
  int _width = 0;

  @published int get width => _width;

  @published set width(int value) {
    if (value != _width) {
      _width = value;

      notify(
        new FrameworkEvent('widthChanged')
      );

      updateControl(3);

      invalidateProperties();
    }
  }

  //---------------------------------
  // percentWidth
  //---------------------------------

  static const EventHook<FrameworkEvent> onPercentWidthChangedEvent = const EventHook<FrameworkEvent>('percentWidthChanged');
  Stream<FrameworkEvent> get onPercentWidthChanged => FlexLayoutMixin.onPercentWidthChangedEvent.forTarget(this);
  double _percentWidth = 0.0;

  @published double get percentWidth => _percentWidth;

  @published set percentWidth(double value) {
    if (value != _percentWidth) {
      _percentWidth = value;

      notify(
        new FrameworkEvent('percentWidthChanged')
      );

      invalidateProperties();
    }
  }

  //---------------------------------
  // height
  //---------------------------------

  static const EventHook<FrameworkEvent> onHeightChangedEvent = const EventHook<FrameworkEvent>('heightChanged');
  Stream<FrameworkEvent> get onHeightChanged => FlexLayoutMixin.onHeightChangedEvent.forTarget(this);
  int _height = 0;

  @published int get height => _height;

  @published set height(int value) {
    if (value != _height) {
      _height = value;

      notify(
        new FrameworkEvent('heightChanged')
      );

      updateControl(4);

      invalidateProperties();
    }
  }

  //---------------------------------
  // percentHeight
  //---------------------------------

  static const EventHook<FrameworkEvent> onPercentHeightChangedEvent = const EventHook<FrameworkEvent>('percentHeightChanged');
  Stream<FrameworkEvent> get onPercentHeightChanged => FlexLayoutMixin.onPercentHeightChangedEvent.forTarget(this);
  double _percentHeight = 0.0;

  @published double get percentHeight => _percentHeight;

  @published set percentHeight(double value) {
    if (value != _percentHeight) {
      _percentHeight = value;

      notify(
        new FrameworkEvent('percentHeightChanged')
      );

      invalidateProperties();
    }
  }

  //---------------------------------
  // paddingLeft
  //---------------------------------

  static const EventHook<FrameworkEvent> onPaddingLeftChangedEvent = const EventHook<FrameworkEvent>('paddingLeftChanged');
  Stream<FrameworkEvent> get onPaddingLeftChanged => FlexLayoutMixin.onPaddingLeftChangedEvent.forTarget(this);
  int _paddingLeft = 0;

  @published int get paddingLeft => _paddingLeft;

  @published set paddingLeft(int value) {
    if (value != _paddingLeft) {
      _paddingLeft = value;

      notify(
        new FrameworkEvent('paddingLeftChanged')
      );

      invalidateProperties();
    }
  }

  //---------------------------------
  // paddingRight
  //---------------------------------

  static const EventHook<FrameworkEvent> onPaddingRightChangedEvent = const EventHook<FrameworkEvent>('paddingRightChanged');
  Stream<FrameworkEvent> get onPaddingRightChanged => FlexLayoutMixin.onPaddingRightChangedEvent.forTarget(this);
  int _paddingRight = 0;

  @published int get paddingRight => _paddingRight;

  @published set paddingRight(int value) {
    if (value != _paddingRight) {
      _paddingRight = value;

      notify(
        new FrameworkEvent('paddingRightChanged')
      );

      invalidateProperties();
    }
  }

  //---------------------------------
  // paddingTop
  //---------------------------------

  static const EventHook<FrameworkEvent> onPaddingTopChangedEvent = const EventHook<FrameworkEvent>('paddingTopChanged');
  Stream<FrameworkEvent> get onPaddingTopChanged => FlexLayoutMixin.onPaddingTopChangedEvent.forTarget(this);
  int _paddingTop = 0;

  @published int get paddingTop => _paddingTop;

  @published set paddingTop(int value) {
    if (value != _paddingTop) {
      _paddingTop = value;

      notify(
        new FrameworkEvent('paddingTopChanged')
      );

      invalidateProperties();
    }
  }

  //---------------------------------
  // paddingBottom
  //---------------------------------

  static const EventHook<FrameworkEvent> onPaddingBottomChangedEvent = const EventHook<FrameworkEvent>('paddingBottomChanged');
  Stream<FrameworkEvent> get onPaddingBottomChanged => FlexLayoutMixin.onPaddingBottomChangedEvent.forTarget(this);
  int _paddingBottom = 0;

  @published int get paddingBottom => _paddingBottom;

  @published set paddingBottom(int value) {
    if (value != _paddingBottom) {
      _paddingBottom = value;

      notify(
        new FrameworkEvent('paddingBottomChanged')
      );

      invalidateProperties();
    }
  }

  //---------------------------------
  // layout
  //---------------------------------

  static const EventHook<FrameworkEvent> onLayoutChangedEvent = const EventHook<FrameworkEvent>('layoutChanged');
  Stream<FrameworkEvent> get onLayoutChanged => FlexLayoutMixin.onLayoutChangedEvent.forTarget(this);
  ILayout _layout;

  @published ILayout get layout => _layout;
  @published set layout(ILayout value) {
    if (value != _layout) {
      _layout = value;

      notify(
        new FrameworkEvent('layoutChanged')
      );

      invalidateProperties();
    }
  }
  
  void updateControl(int type);
}