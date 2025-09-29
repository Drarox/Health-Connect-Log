# Health Connect Log

A modern Flutter app for logging workouts to Health Connect with preset functionality.

## Features

- **Create Workout Presets**: Set up recurring workouts with specific details like duration, time, day of week, and workout type
- **One-Click Logging**: Log your preset workouts to Health Connect with a single tap
- **Modern UI**: Clean, Material 3 design with intuitive navigation
- **Health Connect Integration**: Direct integration with Android's Health Connect platform

## Supported Workout Types

- Martial Arts
- Running
- Cycling
- Swimming
- Yoga
- Strength Training
- Cardio
- Walking
- Other

## How to Use

1. **First Time Setup**: Grant Health Connect permissions when prompted
2. **Create a Preset**: 
   - Tap the + button
   - Enter workout details (name, type, duration)
   - Set schedule (day of week and time)
   - Save the preset
3. **Log Workouts**: Tap "Log Workout" on any preset to add it to Health Connect

## Example Use Case

Create a preset for "Monday Running" with:
- Duration: 1h 30m
- Time: 19:00 (7 PM)
- Day: Monday
- Type: Running

Each week, simply tap "Log Workout" to record your Monday session to Health Connect.

## Requirements

- Android device with Health Connect installed
- Flutter 3.9.2 or higher
- Health Connect permissions

## Getting Started

```bash
flutter pub get
flutter run
```

Make sure Health Connect is installed on your Android device and grant the necessary permissions when prompted.
