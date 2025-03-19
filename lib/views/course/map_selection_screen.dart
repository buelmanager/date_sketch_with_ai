import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapSelectionScreen extends StatefulWidget {
  final String initialAddress;

  const MapSelectionScreen({
    Key? key,
    this.initialAddress = '',
  }) : super(key: key);

  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  NaverMapController? _mapController;

  // 서울 중심 좌표를 기본값으로 설정
  NLatLng _initialPosition = NLatLng(37.5665, 126.9780);
  NLatLng? _selectedPosition;
  String _selectedAddress = '';
  bool _isLoading = true;

  // 마커 설정
  final List<NMarker> _markers = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    // 위치 권한 요청
    await _requestLocationPermission();

    if (!mounted) return;

    // 초기 주소가 있으면 해당 주소의 좌표를 가져옴
    if (widget.initialAddress.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(widget.initialAddress);
        if (!mounted) return;

        if (locations.isNotEmpty) {
          setState(() {
            _initialPosition = NLatLng(locations.first.latitude, locations.first.longitude);
          });
        }
      } catch (e) {
        // 주소 검색 실패 시 현재 위치 사용
        await _getCurrentLocation();
      }
    } else {
      // 초기 주소가 없으면 현재 위치 사용
      await _getCurrentLocation();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isDenied && mounted) {
      // 사용자가 권한을 거부한 경우
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('위치 권한이 필요합니다.')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          _initialPosition = NLatLng(position.latitude, position.longitude);
        });
      }
    } catch (e) {
      // 기본 위치 유지 (서울 중심)
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        if (messenger.mounted) {
          messenger.showSnackBar(
            const SnackBar(content: Text('현재 위치를 가져올 수 없습니다.')),
          );
        }
      }
    }
  }

  void _updatePosition(NLatLng position) {
    setState(() {
      _selectedPosition = position;

      // 기존 마커 모두 제거
      _markers.clear();

      // 새 마커 생성
      final marker = NMarker(
        id: '${position.latitude},${position.longitude}',
        position: position,
      );

      _markers.add(marker);
    });

    // 위치에 해당하는 주소 정보 가져오기
    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(NLatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          // 한국 주소 형식으로 조합
          _selectedAddress = '${place.locality ?? ''} ${place.subLocality ?? ''} ${place.thoroughfare ?? ''} ${place.subThoroughfare ?? ''}'.trim();
          if (_selectedAddress.isEmpty) {
            _selectedAddress = '${place.administrativeArea ?? ''} ${place.locality ?? ''}'.trim();
          }
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = '주소를 가져올 수 없습니다';
      });
    }
  }

  void _moveCameraToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      final latLng = NLatLng(position.latitude, position.longitude);

      if (_mapController != null) {
        // 현재 위치로 카메라 이동
        await _mapController!.updateCamera(
          NCameraUpdate.withParams(
            target: latLng,
            zoom: 15,
          ),
        );

        // 마커 업데이트
        _updatePosition(latLng);
      }
    } catch (e) {
      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        const SnackBar(content: Text('현재 위치를 가져올 수 없습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '위치 선택',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_selectedPosition != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context, {
                  'address': _selectedAddress,
                  'position': {
                    'latitude': _selectedPosition!.latitude,
                    'longitude': _selectedPosition!.longitude,
                  },
                });
              },
              child: const Text(
                '선택',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // 선택한 주소 표시
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '선택한 위치',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedAddress.isEmpty ? '지도에서 위치를 선택해주세요' : _selectedAddress,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // 구분선
          const Divider(height: 1),

          // 네이버 지도
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: _initialPosition,
                  zoom: 15,
                ),
                mapType: NMapType.basic,
                indoorEnable: true,
                locationButtonEnable: false,
              ),
              onMapReady: (controller) {
                setState(() {
                  _mapController = controller;
                  _updatePosition(_initialPosition);
                });
              },
              onMapTapped: (point, latLng) {
                _updatePosition(latLng);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveCameraToCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}