// ignore_for_file: deprecated_member_use, unnecessary_underscores, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:paysuite/view/base/loading_indicator.dart';
import 'package:paysuite/view/base/nothing_to_show_here.dart';
import '../../theme/light_theme.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';

class CustomDropDown extends StatefulWidget {
  final double? height;
  final String? title;
  final IconData? icon;
  final String? svgIcon;
  final Color? iconColor;
  final bool isLeftIcon;
  final double? buttonRadius;
  final TextStyle? headerStyle;
  final Widget? headerRightElement;
  final bool isRequired;
  final List<Map<String, dynamic>> dwItems;
  final String? dwValue;
  final List<String>? values;
  final Function(String?)? onChange;
  final Function(List<String>)? onChangedMulti;
  final bool multiSelect;
  final String idField;
  final String valueField;
  final bool enableSearch;
  final String? hintText;
  final double? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final double dropdownHeight;
  final int pageSize;
  final bool isFloatingLabelBehavior;
  final double? minDropdownWidth;

  const CustomDropDown({
    super.key,
    this.title,
    this.height,
    this.icon,
    this.svgIcon,
    this.iconColor,
    this.buttonRadius,
    this.headerStyle,
    this.headerRightElement,
    this.isRequired = false,
    required this.dwItems,
    this.dwValue,
    this.values,
    this.onChange,
    this.onChangedMulti,
    this.multiSelect = false,
    this.idField = 'id',
    this.valueField = 'value',
    this.enableSearch = true,
    this.hintText,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.dropdownHeight = 350,
    this.pageSize = 20,
    this.isFloatingLabelBehavior = false,
    this.isLeftIcon = false,
    this.minDropdownWidth,
  });

  @override
  State<CustomDropDown> createState() => _FancyDropdownState();
}

class _FancyDropdownState extends State<CustomDropDown> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Map<String, dynamic>> _filteredItems = [];
  List<Map<String, dynamic>> _selectedItems = [];
  String? _displayValue;
  bool _isFiltering = false;
  bool _hasMore = false;
  int _currentPage = 0;
  Timer? _debounce;
  bool _isDropdownOpen = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = List<Map<String, dynamic>>.from(widget.dwItems);
    _initializeSelection();
    _updateDisplayValue();
    _searchController.addListener(_onSearchChanged);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 50 &&
          _hasMore &&
          !_isFiltering) {
        _loadMore();
      }
    });
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _overlayEntry?.markNeedsBuild();
      }
    });
  }

  void _initializeSelection() {
    try {
      if (widget.multiSelect && widget.values != null) {
        final ids = widget.values!.toSet();
        _selectedItems = widget.dwItems
            .where((e) => ids.contains(e[widget.idField]))
            .toList();
      } else if (!widget.multiSelect && widget.dwValue != null) {
        // Fixed: Use try-catch instead of orElse with type mismatch
        Map<String, dynamic>? foundItem;
        for (var item in widget.dwItems) {
          if (item[widget.idField] == widget.dwValue) {
            foundItem = item;
            break;
          }
        }
        if (foundItem != null) {
          _selectedItems = [foundItem];
        } else {
          _selectedItems = [];
        }
      } else {
        _selectedItems = [];
      }
    } catch (e) {
      _selectedItems = [];
    }
  }

  void _updateDisplayValue() {
    if (_selectedItems.isEmpty) {
      _displayValue = null;
    } else if (widget.multiSelect) {
      _displayValue = _selectedItems
          .map((e) => e[widget.valueField])
          .join(', ');
    } else {
      _displayValue = _selectedItems.first[widget.valueField];
    }
  }

  void _onItemTap(Map<String, dynamic> item) {
    setState(() {
      if (widget.multiSelect) {
        final exists = _selectedItems.any(
          (e) => e[widget.idField] == item[widget.idField],
        );
        if (exists) {
          _selectedItems.removeWhere(
            (e) => e[widget.idField] == item[widget.idField],
          );
        } else {
          _selectedItems.add(item);
        }
        widget.onChangedMulti?.call(
          _selectedItems.map((e) => e[widget.idField] as String).toList(),
        );
      } else {
        _selectedItems = [item];
        widget.onChange?.call(item[widget.idField] as String);
        _removeOverlay();
      }
      _updateDisplayValue();
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    setState(() => _isFiltering = true);
    _overlayEntry?.markNeedsBuild();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final query = _searchController.text.toLowerCase();
      setState(() {
        if (query.isEmpty) {
          _filteredItems = List<Map<String, dynamic>>.from(widget.dwItems);
        } else {
          _filteredItems = widget.dwItems
              .where(
                (item) => (item[widget.valueField] ?? '')
                    .toString()
                    .toLowerCase()
                    .contains(query),
              )
              .toList();
        }
        _currentPage = 0;
        _hasMore = _filteredItems.length > widget.pageSize;
        _isFiltering = false;
      });
      _overlayEntry?.markNeedsBuild();
    });
  }

  void _loadMore() {
    if (!_hasMore) return;
    setState(() {
      _currentPage++;
      final end = (_currentPage + 1) * widget.pageSize;
      _hasMore = _filteredItems.length > end;
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_isDropdownOpen) return;

    Future.microtask(() {
      if (!mounted || _isDropdownOpen) return;

      _overlayEntry = _createOverlay();
      if (_overlayEntry != null) {
        Overlay.of(context).insert(_overlayEntry!);
        setState(() {
          _isDropdownOpen = true;
        });
      }
    });
  }

  void _removeOverlay({bool immediate = false}) {
    if (!_isDropdownOpen || _overlayEntry == null) return;

    try {
      // Remove overlay immediately to unblock UI
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isDropdownOpen = false;

      // Reset local states safely
      if (!immediate && mounted && !_isDisposed) {
        _searchFocusNode.unfocus();
        if (!_isDisposed) _searchController.clear();

        _filteredItems = List<Map<String, dynamic>>.from(widget.dwItems);
        _currentPage = 0;
        _isFiltering = false;

        if (mounted) setState(() {});
      }
    } catch (e) {
      // ignore if overlay already removed
    }
  }

  @override
  void didUpdateWidget(covariant CustomDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // dwValue
    if (oldWidget.dwValue != widget.dwValue) {
      _initializeSelection();
      _updateDisplayValue();
      if (mounted) setState(() {});
    }

    // dwItems
    if (oldWidget.dwItems != widget.dwItems) {
      _filteredItems = List<Map<String, dynamic>>.from(widget.dwItems);
      _initializeSelection();
      _updateDisplayValue();
      if (mounted) setState(() {});
    }
  }

  @override
  void deactivate() {
    // Remove overlay synchronously to avoid blocking UI
    _removeOverlay(immediate: true);
    super.deactivate();
  }

  @override
  void dispose() {
    _isDisposed = true;

    // Always remove overlay synchronously first
    _removeOverlay(immediate: true);

    _debounce?.cancel();

    _searchFocusNode.dispose();
    _scrollController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  OverlayEntry _createOverlay() {
    final theme = Theme.of(context);

    return OverlayEntry(
      builder: (context) {
        if (!mounted) return const SizedBox();

        try {
          final mediaQuery = MediaQuery.of(context);
          final screenWidth = mediaQuery.size.width;
          final screenHeight = mediaQuery.size.height;
          final keyboardHeight = mediaQuery.viewInsets.bottom;

          // SAFE AREA (MIUI fix)
          const horizontalPadding = 12.0;
          const verticalPadding = 24.0;

          // WIDTH (center modal safe)
          final double dropdownWidth = screenWidth > 420
              ? 420
              : screenWidth - horizontalPadding * 2;

          // HEIGHT
          final double maxHeight =
              screenHeight - keyboardHeight - verticalPadding * 2;
          final double overlayHeight = widget.dropdownHeight.clamp(
            180.0,
            maxHeight * 0.9,
          );

          // CENTER POSITION
          final double left = (screenWidth - dropdownWidth) / 2;
          final double top =
              (screenHeight - keyboardHeight - overlayHeight) / 2;

          // Pagination
          final itemsToShow = _filteredItems.sublist(
            0,
            ((_currentPage + 1) * widget.pageSize) > _filteredItems.length
                ? _filteredItems.length
                : (_currentPage + 1) * widget.pageSize,
          );

          return Stack(
            children: [
              // BACKDROP (MIUI SAFE)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _removeOverlay,
                  child: Container(color: Colors.black.withOpacity(0.35)),
                ),
              ),

              // CENTER MODAL DROPDOWN
              Positioned(
                left: horizontalPadding,
                right: horizontalPadding,
                top: top,
                height: overlayHeight,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? Dimensions.RADIUS_LARGE,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? theme.cardColor,
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius ?? Dimensions.RADIUS_LARGE,
                      ),
                      border: Border.all(
                        color: widget.borderColor ?? theme.hintColor,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (widget.enableSearch)
                          Padding(
                            padding: const EdgeInsets.all(
                              Dimensions.PADDING_SIZE_LARGE,
                            ),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                hintText: 'search_key'.tr,
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          _searchController.clear();
                                          _onSearchChanged();
                                        },
                                      )
                                    : null,
                              ),
                            ),
                          ),

                        Divider(
                          height: 1,
                          color: theme.hintColor.withOpacity(0.2),
                        ),

                        Expanded(
                          child: _filteredItems.isEmpty
                              ? Center(child: NothingToShowHere())
                              : ListView.separated(
                                  padding: EdgeInsets.zero,
                                  controller: _scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  itemCount:
                                      itemsToShow.length + (_hasMore ? 1 : 0),
                                  separatorBuilder: (_, __) => Divider(
                                    height: 1,
                                    color: theme.hintColor.withOpacity(0.2),
                                  ),
                                  itemBuilder: (_, index) {
                                    if (index < itemsToShow.length) {
                                      final item = itemsToShow[index];
                                      final isSelected = _selectedItems.any(
                                        (e) =>
                                            e[widget.idField] ==
                                            item[widget.idField],
                                      );

                                      return ListTile(
                                        title: Text(
                                          item[widget.valueField] ?? '',
                                        ),
                                        trailing: widget.multiSelect
                                            ? Checkbox(
                                                value: isSelected,
                                                onChanged: (_) =>
                                                    _onItemTap(item),
                                              )
                                            : isSelected
                                            ? Icon(
                                                Icons.check,
                                                color: theme.primaryColor,
                                              )
                                            : null,
                                        onTap: () => _onItemTap(item),
                                      );
                                    }

                                    return const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Center(child: LoadingIndicator()),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } catch (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _removeOverlay();
          });
          return const SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (_isDropdownOpen) {
          _removeOverlay();
          return false;
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Row(
              children: [
                Text(
                  widget.title!,
                  style:
                      widget.headerStyle ??
                      googleSansFlexMedium.copyWith(
                        color: (Get.isDarkMode
                            ? LightAppColor.cardColor
                            : LightAppColor.blackGrey),
                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      ),
                ),
                if (widget.isRequired)
                  const Text(" *", style: TextStyle(color: Colors.red)),
                const Spacer(),
                widget.headerRightElement ?? const SizedBox(),
              ],
            ),
          SizedBox(height: widget.title != null ? 6 : 0),
          CompositedTransformTarget(
            link: _layerLink,
            child: InkWell(
              onTap: _toggleDropdown,
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? Dimensions.RADIUS_SMALL,
              ),
              child: Container(
                key: _key,
                height: widget.height ?? 52,
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isLeftIcon
                      ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                      : Dimensions.PADDING_SIZE_DEFAULT,
                ),
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColor ??
                      Theme.of(context).hintColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(
                    widget.buttonRadius ?? 10,
                  ),
                  border: Border.all(
                    color: widget.borderColor ?? theme.hintColor,
                  ),
                ),
                child: Row(
                  children: [
                    if (widget.isLeftIcon)
                      widget.svgIcon != null
                          ? SvgPicture.asset(
                              widget.svgIcon!,
                              colorFilter: ColorFilter.mode(
                                widget.iconColor ??
                                    Theme.of(context).disabledColor,
                                BlendMode.srcIn,
                              ),
                              width: 18,
                            )
                          : Icon(
                              widget.icon ?? Icons.keyboard_arrow_down,
                              color:
                                  widget.iconColor ??
                                  Theme.of(context).disabledColor,
                            ),

                    if (widget.isLeftIcon)
                      SizedBox(width: Dimensions.FREE_SIZE_SMALL),
                    Expanded(
                      child: Text(
                        _displayValue ?? widget.hintText ?? "Select",
                        overflow: TextOverflow.ellipsis,
                        style: _displayValue == null
                            ? googleSansFlexRegular.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                              )
                            : Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                color: Get.isDarkMode
                                    ? LightAppColor.cardColor
                                    : LightAppColor.black,
                                fontWeight: FontWeight.w400,
                              ),
                      ),
                    ),
                    if (!widget.isLeftIcon)
                      Icon(
                        widget.icon ?? Icons.keyboard_arrow_down,
                        color:
                            widget.iconColor ?? Theme.of(context).disabledColor,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
