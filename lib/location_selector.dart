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
  LocationModel? _currentLocation;

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
    _loadCurrentLocationAndSuggestions();
  }

  Future<void> _loadCurrentLocationAndSuggestions() async {
    try {
      final currentLocation = await _locationService.getDeviceLocation();
      setState(() {
        if (currentLocation != null) {
          _currentLocation = LocationModel(
            name: currentLocation.name,
            displayName:
                widget.isVietnamese ? 'Vị trí hiện tại' : 'Current Location',
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude,
          );
        }
        _updateFilteredLocations();
      });
    } catch (e) {
      setState(() {
        _updateFilteredLocations();
      });
    }
  }

  void _updateFilteredLocations() {
    _filteredLocations = [];

    if (_currentLocation != null) {
      _filteredLocations.add(_currentLocation!);
    }

    _filteredLocations.addAll(_defaultSuggestions);
  }

  Future<void> _searchLocations(String query) async {
    setState(() => _loading = true);
    try {
      final results = await _locationService.searchLocation(query);
      List<LocationModel> finalResults = [];
      if (_currentLocation != null) {
        finalResults.add(_currentLocation!);
      }
      finalResults.addAll(results);

      setState(() {
        _filteredLocations = finalResults;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _filteredLocations =
            _currentLocation != null ? [_currentLocation!] : [];
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      _searchLocations(query);
    } else {
      setState(() {
        _updateFilteredLocations();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.maxFinite,
        height: 500,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.white,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'imgs/location.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.location_city, color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.isVietnamese ? 'Chọn vị trí' : 'Select Location',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.isVietnamese
                      ? 'Tìm kiếm vị trí...'
                      : 'Search location...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      'imgs/search.png',
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.search, color: Colors.blue),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue.shade100),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _loading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade400),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.isVietnamese
                                ? 'Đang tìm kiếm...'
                                : 'Searching...',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredLocations.length,
                      itemBuilder: (context, index) {
                        final location = _filteredLocations[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _isCurrentLocation(location)
                                        ? location.displayName
                                        : (widget.isVietnamese
                                            ? _getVietnameseName(location.name)
                                            : location.name),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _isCurrentLocation(location)
                                    ? Colors.green.shade100
                                    : Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _isCurrentLocation(location)
                                    ? Icons.my_location
                                    : Icons.location_on,
                                color: _isCurrentLocation(location)
                                    ? Colors.green.shade600
                                    : Colors.blue.shade400,
                                size: 24,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey.shade500,
                            ),
                            onTap: () {
                              widget.onLocationSelected(location);
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isCurrentLocation(LocationModel location) {
    return _currentLocation != null &&
        _currentLocation!.name == location.name &&
        _currentLocation!.displayName == location.displayName;
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
