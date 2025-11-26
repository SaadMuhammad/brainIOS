# brainIOS
the strucutre you need to create:

Neudio-Brain-Music/
├── README.md                # Documentation (How to run, setup instructions)
├── .gitignore               # Standard Swift/Python gitignore
├── Python_Lab/              # 🧪 THE LAB: Data Analysis & ML Training
│   ├── data/                # Store your recorded .csv files here
│   ├── 1_visualize_eeg.py   # Code to understand your data (EDA)
│   ├── 2_train_model.py     # Code to create the CoreML model
│   └── requirements.txt     # Python dependencies (mne, pandas, coremltools)
└── NeudioiOS/               # 🚀 THE APP: The Xcode Project
    ├── NeudioiOS.xcodeproj
    └── NeudioiOS/
        ├── App/             # App Lifecycle (Main entry point)
        ├── Models/          # Data Structures
        ├── Services/        # The "Engine Room" (Input, Processing, Output)
        ├── ViewModels/      # Connects Logic to UI
        ├── Views/           # User Interface (SwiftUI)
        └── Resources/       # Assets & .mlmodel files


-----------------------------------------------------------------------------------------
🏛️ Deep Dive: The iOS Folder (NeudioiOS/)
In Swift, unlike Python, you do not need to write import File to use code from another file in the same project. All files in the folders below can "see" each other automatically.

1. Services/ (The Logic Pipeline)
This is where 90% of your work goes.

BLEManager.swift (Input)

What it does: Connects to Bluetooth, handles disconnections, and extracts raw bytes.

Key Code: CBCentralManagerDelegate, packet decoding logic.

Input: Nothing.

Output: Sends [Float] array (raw brain voltage) to the Delegate.

BrainDSP.swift (Signal Processing)

What it does: The "Math Whiz." Takes raw numbers and finds frequencies.

Key Code: Accelerate framework, vDSP_fft_zrip.

Input: [Float] (Raw samples from BLE).

Output: BrainBandPower struct (Alpha, Beta, Theta values).

BrainStateMachine.swift (Decision Logic)

What it does: The "Brain." It decides what the signal means.

Key Code: This is where you implement your Heuristics and ML.

Why here? Keep the decision logic separate from the math.

Content:

Swift

// Example Function inside:
func determineState(bands: BrainBandPower) -> BrainState {
    // 1. Simple Heuristic
    if bands.alpha > 0.8 { return .relaxed }

    // 2. Score Heuristic (Focus Index)
    let ratio = bands.beta / bands.theta
    if ratio > 2.0 { return .focused }

    // 3. ML Model (Optional)
    // let prediction = try? model.prediction(input: ...)

    return .neutral
}
MIDIHelper.swift (Output)

What it does: The "messenger." Talks to GarageBand.

Key Code: CoreMIDI, MIDISourceCreate.

Input: A score (0.0 to 1.0) or State.

Output: MIDI CC messages to the system.


-----------------------------------------------------
This is a professional, clean structure designed for a hackathon. It separates the "Lab" (Python research) from the "Factory" (iOS App), keeping your workflow organized.

📂 Root Directory Structure
This is what your GitHub repository should look like at the top level.

Plaintext

Neudio-Brain-Music/
├── README.md                # Documentation (How to run, setup instructions)
├── .gitignore               # Standard Swift/Python gitignore
├── Python_Lab/              # 🧪 THE LAB: Data Analysis & ML Training
│   ├── data/                # Store your recorded .csv files here
│   ├── 1_visualize_eeg.py   # Code to understand your data (EDA)
│   ├── 2_train_model.py     # Code to create the CoreML model
│   └── requirements.txt     # Python dependencies (mne, pandas, coremltools)
└── NeudioiOS/               # 🚀 THE APP: The Xcode Project
    ├── NeudioiOS.xcodeproj
    └── NeudioiOS/
        ├── App/             # App Lifecycle (Main entry point)
        ├── Models/          # Data Structures
        ├── Services/        # The "Engine Room" (Input, Processing, Output)
        ├── ViewModels/      # Connects Logic to UI
        ├── Views/           # User Interface (SwiftUI)
        └── Resources/       # Assets & .mlmodel files
🏛️ Deep Dive: The iOS Folder (NeudioiOS/)
In Swift, unlike Python, you do not need to write import File to use code from another file in the same project. All files in the folders below can "see" each other automatically.

1. Services/ (The Logic Pipeline)
This is where 90% of your work goes.

BLEManager.swift (Input)

What it does: Connects to Bluetooth, handles disconnections, and extracts raw bytes.

Key Code: CBCentralManagerDelegate, packet decoding logic.

Input: Nothing.

Output: Sends [Float] array (raw brain voltage) to the Delegate.

BrainDSP.swift (Signal Processing)

What it does: The "Math Whiz." Takes raw numbers and finds frequencies.

Key Code: Accelerate framework, vDSP_fft_zrip.

Input: [Float] (Raw samples from BLE).

Output: BrainBandPower struct (Alpha, Beta, Theta values).

BrainStateMachine.swift (Decision Logic)

What it does: The "Brain." It decides what the signal means.

Key Code: This is where you implement your Heuristics and ML.

Why here? Keep the decision logic separate from the math.

Content:

Swift

// Example Function inside:
func determineState(bands: BrainBandPower) -> BrainState {
    // 1. Simple Heuristic
    if bands.alpha > 0.8 { return .relaxed }

    // 2. Score Heuristic (Focus Index)
    let ratio = bands.beta / bands.theta
    if ratio > 2.0 { return .focused }

    // 3. ML Model (Optional)
    // let prediction = try? model.prediction(input: ...)

    return .neutral
}
MIDIHelper.swift (Output)

What it does: The "messenger." Talks to GarageBand.

Key Code: CoreMIDI, MIDISourceCreate.

Input: A score (0.0 to 1.0) or State.

Output: MIDI CC messages to the system.

2. Models/ (Data Structures)
Simple files that define what data looks like.

BrainData.swift

Content:

sample swift code:
struct BrainBandPower {
    let delta: Float
    let theta: Float
    let alpha: Float
    let beta: Float
}

enum BrainState {
    case relaxed
    case focused
    case flow
    case stressed
}

-----------------------------------------------------------------
3. ViewModels/ ( The Bridge)
MainViewModel.swift

What it does: It owns instances of BLEManager, BrainDSP, and MIDIHelper. It runs the main loop.

Data Flow: BLE -> DSP -> StateMachine -> MIDI.

Code: This updates @Published variables so the UI can show "Connected" or graphs.

4. Views/ (The UI)
DashboardView.swift: Shows the connection status and maybe a simple bar graph of Alpha/Beta.

DebugView.swift: A text list showing the raw numbers coming in. Build this first to verify your data!

------------------------------------------------------------------------------------------------------

This is a professional, clean structure designed for a hackathon. It separates the "Lab" (Python research) from the "Factory" (iOS App), keeping your workflow organized.

📂 Root Directory Structure
This is what your GitHub repository should look like at the top level.

Plaintext

Neudio-Brain-Music/
├── README.md                # Documentation (How to run, setup instructions)
├── .gitignore               # Standard Swift/Python gitignore
├── Python_Lab/              # 🧪 THE LAB: Data Analysis & ML Training
│   ├── data/                # Store your recorded .csv files here
│   ├── 1_visualize_eeg.py   # Code to understand your data (EDA)
│   ├── 2_train_model.py     # Code to create the CoreML model
│   └── requirements.txt     # Python dependencies (mne, pandas, coremltools)
└── NeudioiOS/               # 🚀 THE APP: The Xcode Project
    ├── NeudioiOS.xcodeproj
    └── NeudioiOS/
        ├── App/             # App Lifecycle (Main entry point)
        ├── Models/          # Data Structures
        ├── Services/        # The "Engine Room" (Input, Processing, Output)
        ├── ViewModels/      # Connects Logic to UI
        ├── Views/           # User Interface (SwiftUI)
        └── Resources/       # Assets & .mlmodel files
🏛️ Deep Dive: The iOS Folder (NeudioiOS/)
In Swift, unlike Python, you do not need to write import File to use code from another file in the same project. All files in the folders below can "see" each other automatically.

1. Services/ (The Logic Pipeline)
This is where 90% of your work goes.

BLEManager.swift (Input)

What it does: Connects to Bluetooth, handles disconnections, and extracts raw bytes.

Key Code: CBCentralManagerDelegate, packet decoding logic.

Input: Nothing.

Output: Sends [Float] array (raw brain voltage) to the Delegate.

BrainDSP.swift (Signal Processing)

What it does: The "Math Whiz." Takes raw numbers and finds frequencies.

Key Code: Accelerate framework, vDSP_fft_zrip.

Input: [Float] (Raw samples from BLE).

Output: BrainBandPower struct (Alpha, Beta, Theta values).

BrainStateMachine.swift (Decision Logic)

What it does: The "Brain." It decides what the signal means.

Key Code: This is where you implement your Heuristics and ML.

Why here? Keep the decision logic separate from the math.

Content:

Swift

// Example Function inside:
func determineState(bands: BrainBandPower) -> BrainState {
    // 1. Simple Heuristic
    if bands.alpha > 0.8 { return .relaxed }

    // 2. Score Heuristic (Focus Index)
    let ratio = bands.beta / bands.theta
    if ratio > 2.0 { return .focused }

    // 3. ML Model (Optional)
    // let prediction = try? model.prediction(input: ...)

    return .neutral
}
MIDIHelper.swift (Output)

What it does: The "messenger." Talks to GarageBand.

Key Code: CoreMIDI, MIDISourceCreate.

Input: A score (0.0 to 1.0) or State.

Output: MIDI CC messages to the system.

2. Models/ (Data Structures)
Simple files that define what data looks like.

BrainData.swift

Content:

Swift

struct BrainBandPower {
    let delta: Float
    let theta: Float
    let alpha: Float
    let beta: Float
}

enum BrainState {
    case relaxed
    case focused
    case flow
    case stressed
}
3. ViewModels/ ( The Bridge)
MainViewModel.swift

What it does: It owns instances of BLEManager, BrainDSP, and MIDIHelper. It runs the main loop.

Data Flow: BLE -> DSP -> StateMachine -> MIDI.

Code: This updates @Published variables so the UI can show "Connected" or graphs.

4. Views/ (The UI)
DashboardView.swift: Shows the connection status and maybe a simple bar graph of Alpha/Beta.

DebugView.swift: A text list showing the raw numbers coming in. Build this first to verify your data!

🧪 Deep Dive: The Python Lab (Python_Lab/)
This folder is not part of the Xcode app. You run this on your laptop to understand the data before you code the Swift logic.

1_visualize_eeg.py (EDA - Exploratory Data Analysis)
Goal: Answer the question "What does the data actually look like?"

Input: A .csv file you recorded using your MacOS prototype.

Code:

Load CSV with pandas.

Plot raw waves with matplotlib (check for noise/spikes).

Run a test FFT (using scipy.signal) to see if you can visually spot Alpha waves when you closed your eyes.

Result: A graph image. If you see a peak at 10Hz, your hardware works.

2_train_model.py (Machine Learning)
Goal: Create the .mlmodel file for the app.

Code:

Load CSV.

Label data (e.g., 0-30s = "Relaxed", 30-60s = "Math Task").

Train RandomForestClassifier from sklearn.

Export using coremltools.

Output: BrainClassifier.mlmodel (Move this file into NeudioiOS/Resources/).

--------------------------------------------------------------------------------------------

🔄 How the Data Flows (The "Main Loop")
In MainViewModel.swift, your code will look roughly like this (simplified):

sample swift code:
// This function triggers every time Bluetooth sends ~12 packets
func onDataReceived(rawBytes: [Float]) {
    
    // 1. DATA LOGGING (For your Python Lab)
    // Save these rawBytes to a CSV file on the phone for later analysis
    DataLogger.shared.save(rawBytes)

    // 2. SIGNAL PROCESSING
    let bands = BrainDSP.shared.process(rawBytes)
    
    // 3. DECISION MAKING (Choose your strategy)
    // Strategy A: Heuristic (Ratio)
    let focusScore = bands.beta / bands.alpha
    
    // Strategy B: Machine Learning
    // let state = BrainStateMachine.shared.predict(bands)
    
    // 4. OUTPUT
    if focusScore > 1.5 {
        MIDIHelper.shared.send(value: 127) // High Intensity
    } else {
        MIDIHelper.shared.send(value: 50)  // Low Intensity
    }
}

-----------------------------------
