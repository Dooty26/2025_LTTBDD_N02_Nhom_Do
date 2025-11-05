import 'package:flutter/material.dart';
import 'location_service.dart';

class LocationSelectorDialog extends StatefulWidget {
  final bool isVietnamese;
  final Function(LocationModel) onLocationSelected;

  const LocationSelectorDialog({
    super.key,
    required this.isVietnamese,
    required this.onLocationSelected,
  });

  @override
  State<LocationSelectorDialog> createState() => _LocationSelectorDialogState();
}

class _LocationSelectorDialogState extends State<LocationSelectorDialog> {
  final LocationService _locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();
  List<LocationModel> _filteredLocations = [];
  bool _loading = false;

  // Danh sách vị trí mặc định gợi ý
  final List<LocationModel> _defaultSuggestions = [
    LocationModel(name: 'Ha Noi', displayName: 'Hà Nội'),
    LocationModel(
        name: 'Ho Chi Minh City', displayName: 'Thành phố Hồ Chí Minh'),
    LocationModel(name: 'Da Nang', displayName: 'Đà Nẵng'),
    LocationModel(name: 'Hai Phong', displayName: 'Hải Phòng'),
    LocationModel(name: 'Can Tho', displayName: 'Cần Thơ'),
  ];

  @override
  void initState() {
    super.initState();
    // Hiển thị mặc định các vị trí gợi ý khi mở dialog
    _filteredLocations = List<LocationModel>.from(_defaultSuggestions);
  }

  Future<void> _searchLocations(String query) async {
    setState(() => _loading = true);
    try {
      final results = await _locationService.searchLocation(query);
      setState(() {
        _filteredLocations = results;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _filteredLocations = [];
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      _searchLocations(query);
    } else {
      setState(() {
        _filteredLocations = List<LocationModel>.from(_defaultSuggestions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isVietnamese ? 'Chọn vị trí' : 'Select Location'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.isVietnamese
                    ? 'Tìm kiếm vị trí...'
                    : 'Search location...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredLocations.length,
                      itemBuilder: (context, index) {
                        final location = _filteredLocations[index];
                        return ListTile(
                          title: Text(
                            widget.isVietnamese
                                ? _getVietnameseName(location.name)
                                : location.name,
                          ),
                          leading:
                              const Icon(Icons.location_on, color: Colors.grey),
                          onTap: () {
                            widget.onLocationSelected(location);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.isVietnamese ? 'Hủy' : 'Cancel'),
        ),
      ],
    );
  }

  String _getVietnameseName(String name) {
    const vnMap = {
      'Ha Noi': 'Hà Nội',
      'Ho Chi Minh City': 'Thành phố Hồ Chí Minh',
      'Da Nang': 'Đà Nẵng',
      'Hai Phong': 'Hải Phòng',
      'Can Tho': 'Cần Thơ',
      'Nha Trang': 'Nha Trang',
      'Hue': 'Huế',
      'Vung Tau': 'Vũng Tàu',
      'Da Lat': 'Đà Lạt',
      'Phan Thiet': 'Phan Thiết',
    };
    return vnMap[name] ?? name;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
