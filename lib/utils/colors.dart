import 'package:flutter/material.dart';

// Blindly App Color Palette
const primary = Color(0xFF8E44AD); // Primary purple
const accent = Color(0xFFF39C12); // Accent orange
const background = Color(0xFF121212); // Dark background
const surface = Color(0xFF1E1E1E); // Surface color
const textLight = Color(0xFFFFFFFF); // Light text
const textGrey = Color(0xFFCCCCCC); // Grey text for avatars before reveal
const buttonText = Color(0xFFFFFFFF); // Button text color

// Legacy colors (keeping for backward compatibility)
const secondary = Color(0xFFF4A261); // Warm Sandstone
const darkPrimary = Color(0xFF1A3C5A); // Midnight Sea
const black = Color(0xFF121212); // Deep Charcoal
const white = Color(0xFFF5F6F5); // Soft Cloud
const grey = Color(0xFF8A8A8A); // Stone Grey

TimeOfDay parseTime(String timeString) {
  List<String> parts = timeString.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}
