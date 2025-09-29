import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_preset.dart';

class StorageService {
  static const String _presetsKey = 'workout_presets';

  static Future<List<WorkoutPreset>> getPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final presetsJson = prefs.getStringList(_presetsKey) ?? [];
    
    return presetsJson
        .map((json) => WorkoutPreset.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> savePreset(WorkoutPreset preset) async {
    final presets = await getPresets();
    final existingIndex = presets.indexWhere((p) => p.id == preset.id);
    
    if (existingIndex >= 0) {
      presets[existingIndex] = preset;
    } else {
      presets.add(preset);
    }
    
    await _savePresets(presets);
  }

  static Future<void> deletePreset(String id) async {
    final presets = await getPresets();
    presets.removeWhere((preset) => preset.id == id);
    await _savePresets(presets);
  }

  static Future<void> _savePresets(List<WorkoutPreset> presets) async {
    final prefs = await SharedPreferences.getInstance();
    final presetsJson = presets
        .map((preset) => jsonEncode(preset.toJson()))
        .toList();
    
    await prefs.setStringList(_presetsKey, presetsJson);
  }
}