# Neudio Brain Music

This repository contains two tightly linked pieces:

- **NeudioiOS/** – The SwiftUI app that connects to a BLE EEG device, processes brain signals, and outputs MIDI.
- **Python_Lab/** – A lightweight lab environment for exploring recordings and training a CoreML model.

The layout mirrors the scaffold requested for the project so you can quickly find the right place to work.

```
Neudio-Brain-Music/
├── README.md
├── .gitignore
├── Python_Lab/
│   ├── data/
│   ├── 1_visualize_eeg.py
│   ├── 2_train_model.py
│   └── requirements.txt
└── NeudioiOS/
    ├── NeudioiOS.xcodeproj
    └── NeudioiOS/
        ├── App/
        ├── Models/
        ├── Services/
        ├── ViewModels/
        ├── Views/
        └── Resources/
```

## Getting Started (Python_Lab)

1. Create a virtual environment and install dependencies:
   ```bash
   python -m venv .venv
   source .venv/bin/activate
   pip install -r Python_Lab/requirements.txt
   ```
2. Place recorded CSV files inside `Python_Lab/data/`.
3. Explore the data:
   ```bash
   python Python_Lab/1_visualize_eeg.py --csv Python_Lab/data/example.csv --sample-rate 256
   ```
4. Train and export a CoreML model (expects a `label` column in the CSV):
   ```bash
   python Python_Lab/2_train_model.py --csv Python_Lab/data/labeled.csv --labels relaxed focused --output NeudioiOS/NeudioiOS/Resources/BrainClassifier.mlmodel
   ```

## iOS App Overview (NeudioiOS)

- **App/**: `NeudioApp.swift` bootstraps the SwiftUI hierarchy.
- **Models/**: `BrainData.swift` defines `BrainBandPower` and `BrainState`.
- **Services/**: Core logic including `BLEManager`, `BrainDSP`, `BrainStateMachine`, `MIDIHelper`, and `DataLogger`.
- **ViewModels/**: `MainViewModel` orchestrates BLE -> DSP -> State -> MIDI and publishes UI state.
- **Views/**: `DashboardView` shows connection status and band bars; `DebugView` lists raw band values.
- **Resources/**: Place assets and `.mlmodel` files here.

### Running the App

1. Open `NeudioiOS/NeudioiOS.xcodeproj` in Xcode.
2. Select the `NeudioApp` target and your preferred simulator or device.
3. Build and run. The placeholder BLE, DSP, and MIDI logic can be expanded to talk to real hardware and models.

### Data Flow Reference

BLE samples → `BrainDSP.process` → `BrainStateMachine.determineState` → MIDI output via `MIDIHelper`. Samples are also saved with `DataLogger` for later analysis in `Python_Lab`.

## Notes

- The Swift code is scaffolding: fill in real BLE packet handling, DSP band power calculations, and MIDI mappings based on your hardware and model.
- Add your trained `BrainClassifier.mlmodel` to `NeudioiOS/NeudioiOS/Resources/` and reference it from `BrainStateMachine` when ready.
