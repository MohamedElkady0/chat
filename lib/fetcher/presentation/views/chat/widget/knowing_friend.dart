import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 1. تعريف متغيرات الحالة
  LatLng? _currentPosition; // لتخزين موقع المستخدم الحالي
  String _currentAddress = 'لم يتم تحديد العنوان بعد'; // لتخزين العنوان النصي
  final MapController _mapController = MapController(); // للتحكم بالخريطة
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // جلب الموقع عند بدء تشغيل الشاشة
  }

  Future<void> _getCurrentLocation() async {
    // ... (كل الكود السابق يبقى كما هو حتى تصل إلى setState)

    // الحصول على الموقع باستخدام geolocator
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // تحويل كائن Position إلى LatLng
    final newPosition = LatLng(position.latitude, position.longitude);

    // تحديث الحالة أولاً لإعادة بناء الواجهة مع الموقع الجديد
    setState(() {
      _currentPosition = newPosition;
      _isLoading = false;
    });

    // *** التعديل هنا ***
    // انتظر حتى يتم رسم الإطار، ثم حرك الخريطة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _currentPosition != null) {
        _mapController.move(_currentPosition!, 4.0);
      }
    });

    print("Current Position: $_currentPosition");
    // جلب العنوان
    _getAddressFromLatLng(position);
  }

  // 3. دالة لتحويل الإحداثيات إلى عنوان باستخدام geocoding
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.street}, ${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _currentAddress = "لا يمكن جلب العنوان";
      });
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter:
                _currentPosition ?? const LatLng(51.5, -0.09), // موقع افتراضي
            initialZoom: 4.0,
          ),
          children: [
            // طبقة الخريطة الأساسية
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.my_chat',
            ),
            // طبقة العلامات (Markers)
            if (_currentPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _currentPosition!,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
          ],
        );
  }
}
