import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Get all events
  static Future<dynamic> getEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get specific event
  static Future<dynamic> getEvent(String eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events/$eventId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Event not found');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Generate QR code for event
  static Future<dynamic> generateQrCode(String eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/qr/generate/$eventId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to generate QR code');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Verify QR and mint proof
  static Future<dynamic> verifyAndMintProof({
    required String qrString,
    required String userAddress,
    required String eventId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/proof/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'qr': qrString,
          'user_address': userAddress,
          'event_id': eventId,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to verify QR code');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get user proofs
  static Future<dynamic> getUserProofs(String userAddress) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/proof/user/$userAddress'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load proofs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
