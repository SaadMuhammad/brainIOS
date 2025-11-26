"""Exploratory data analysis for recorded EEG CSV files.

Steps
-----
1. Load a CSV file containing EEG samples (one channel per column).
2. Plot the raw signals to inspect noise or dropouts.
3. Compute and plot a simple FFT to look for band power peaks.

Usage
-----
python 1_visualize_eeg.py --csv data/example.csv --sample-rate 256
"""

import argparse
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy import signal


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Visualize EEG CSV recordings.")
    parser.add_argument(
        "--csv",
        type=Path,
        required=True,
        help="Path to the recorded EEG CSV file (columns = channels).",
    )
    parser.add_argument(
        "--sample-rate",
        type=float,
        default=256.0,
        help="Sampling rate in Hz used during recording (default: 256 Hz).",
    )
    return parser.parse_args()


def load_eeg(csv_path: Path) -> pd.DataFrame:
    if not csv_path.exists():
        raise FileNotFoundError(f"CSV file not found: {csv_path}")
    df = pd.read_csv(csv_path)
    if df.empty:
        raise ValueError("CSV file is empty. Record data before running analysis.")
    return df


def plot_raw(df: pd.DataFrame) -> None:
    plt.figure(figsize=(12, 6))
    for column in df.columns:
        plt.plot(df[column], label=column)
    plt.title("Raw EEG Signals")
    plt.xlabel("Sample")
    plt.ylabel("Voltage (a.u.)")
    plt.legend(loc="upper right")
    plt.tight_layout()


def plot_fft(df: pd.DataFrame, sample_rate: float) -> None:
    plt.figure(figsize=(12, 6))
    for column in df.columns:
        freqs, psd = signal.welch(df[column].values, fs=sample_rate, nperseg=1024)
        plt.semilogy(freqs, psd, label=column)
    plt.title("Power Spectral Density")
    plt.xlabel("Frequency (Hz)")
    plt.ylabel("Power/Frequency (dB/Hz)")
    plt.xlim(0, 60)
    plt.legend(loc="upper right")
    plt.tight_layout()


def main() -> None:
    args = parse_args()
    df = load_eeg(args.csv)

    plot_raw(df)
    plot_fft(df, args.sample_rate)
    plt.show()


if __name__ == "__main__":
    main()
