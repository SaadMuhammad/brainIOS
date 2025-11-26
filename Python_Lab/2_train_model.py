"""Train a simple classifier and export it to CoreML.

Usage
-----
python 2_train_model.py --csv data/example.csv --labels relaxed focused
"""

import argparse
from pathlib import Path

import coremltools as ct
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Train a CoreML EEG classifier.")
    parser.add_argument("--csv", type=Path, required=True, help="Path to labeled EEG CSV.")
    parser.add_argument(
        "--labels",
        nargs=2,
        metavar=("RELAXED_LABEL", "FOCUSED_LABEL"),
        default=["relaxed", "focused"],
        help="Label names matching the rows in the CSV (two-class example).",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("BrainClassifier.mlmodel"),
        help="Where to write the CoreML model.",
    )
    return parser.parse_args()


def load_dataset(csv_path: Path) -> tuple[np.ndarray, np.ndarray]:
    if not csv_path.exists():
        raise FileNotFoundError(f"CSV file not found: {csv_path}")
    df = pd.read_csv(csv_path)
    if "label" not in df.columns:
        raise ValueError("CSV must contain a 'label' column with class names.")
    y = df.pop("label").values
    X = df.values.astype(float)
    return X, y


def build_pipeline() -> Pipeline:
    return Pipeline(
        [
            ("scale", StandardScaler()),
            ("model", RandomForestClassifier(n_estimators=200, random_state=42)),
        ]
    )


def export_coreml(model: Pipeline, output: Path, class_labels: list[str]) -> None:
    # Convert scikit-learn pipeline to CoreML
    mlmodel = ct.converters.sklearn.convert(
        model,
        input_features=[("eeg_features", ct.converters.sklearn.array_shape(model.n_features_in_))],
        output_feature_names=["brain_state"],
        class_labels=class_labels,
    )
    mlmodel.save(output)
    print(f"Saved CoreML model to {output}")


def main() -> None:
    args = parse_args()
    X, y = load_dataset(args.csv)

    X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=42)

    pipeline = build_pipeline()
    pipeline.fit(X_train, y_train)
    val_accuracy = pipeline.score(X_val, y_val)
    print(f"Validation accuracy: {val_accuracy:.3f}")

    export_coreml(pipeline, args.output, class_labels=args.labels)


if __name__ == "__main__":
    main()
