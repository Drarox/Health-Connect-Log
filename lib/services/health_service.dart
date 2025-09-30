import 'package:health/health.dart';
import '../models/workout_preset.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final Health _health = Health();
  bool _isAuthorized = false;

  static const List<HealthDataType> _types = [
    HealthDataType.WORKOUT,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  static const List<HealthDataAccess> _permissions = [
    HealthDataAccess.WRITE,
    HealthDataAccess.WRITE,
  ];

  Future<bool> requestPermissions() async {
    try {
      // Check if Health Connect is available first
      print('Checking Health Connect availability...');
      
      // Try to get health data to test connection
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      
      try {
        final healthData = await _health.getHealthDataFromTypes(
          types: [HealthDataType.STEPS],
          startTime: yesterday,
          endTime: now,
        );
        print('Health Connect is accessible, got ${healthData.length} data points');
      } catch (e) {
        print('Health Connect access test failed: $e');
      }
      
      // Request authorization
      print('Requesting Health Connect permissions...');
      _isAuthorized = await _health.requestAuthorization(_types, permissions: _permissions);
      print('Health Connect authorization result: $_isAuthorized');
      return _isAuthorized;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }

  Future<bool> hasPermissions() async {
    try {
      return await _health.hasPermissions(_types, permissions: _permissions) ?? false;
    } catch (e) {
      print('Error checking permissions: $e');
      return false;
    }
  }

  Future<bool> logWorkout(WorkoutPreset preset, DateTime workoutDate) async {
    try {
      // Check if we have permissions first
      final hasPerms = await hasPermissions();
      if (!hasPerms) {
        print('No permissions, requesting...');
        final authorized = await requestPermissions();
        if (!authorized) {
          print('Failed to get authorization');
          return false;
        }
      }

      final startTime = DateTime(
        workoutDate.year,
        workoutDate.month,
        workoutDate.day,
        preset.hour,
        preset.minute,
      );
      final endTime = startTime.add(preset.duration);

      final workoutType = _getWorkoutType(preset.type);
      
      print('Logging workout: ${preset.name} from $startTime to $endTime, type: $workoutType');
      
      // Log the workout with calories if provided
      final workoutSuccess = await _health.writeWorkoutData(
        activityType: workoutType,
        start: startTime,
        end: endTime,
        totalEnergyBurned: preset.calories,
        totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
      );

      print('Workout logging result: $workoutSuccess');
      if (preset.calories != null) {
        print('Logged workout with ${preset.calories} kcal');
      }

      return workoutSuccess;
    } catch (e) {
      print('Error logging workout: $e');
      return false;
    }
  }

  HealthWorkoutActivityType _getWorkoutType(String type) {
    switch (type.toLowerCase()) {
      case 'martial arts':
        return HealthWorkoutActivityType.MARTIAL_ARTS;
      case 'running':
        return HealthWorkoutActivityType.RUNNING;
      case 'cycling':
        return HealthWorkoutActivityType.BIKING;
      case 'swimming':
        return HealthWorkoutActivityType.SWIMMING;
      case 'yoga':
        return HealthWorkoutActivityType.YOGA;
      case 'strength training':
        return HealthWorkoutActivityType.STRENGTH_TRAINING;
      case 'cardio':
        return HealthWorkoutActivityType.OTHER;
      case 'walking':
        return HealthWorkoutActivityType.WALKING;
      default:
        return HealthWorkoutActivityType.OTHER;
    }
  }

  static List<String> get availableWorkoutTypes => [
    'Martial Arts',
    'Running',
    'Cycling',
    'Swimming',
    'Yoga',
    'Strength Training',
    'Cardio',
    'Walking',
    'Other',
  ];
}