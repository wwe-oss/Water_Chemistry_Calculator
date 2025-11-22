using System.Collections.Generic;

namespace WaterChem.Domain.Equipment
{
    /// <summary>
    /// Represents a physical measurement device such as:
    ///   - pH meter
    ///   - EC/TDS meter
    ///   - Thermometer
    ///   - Combination probes
    ///
    /// Contains NO logic or transformations.
    /// Pure data loaded from configuration.
    /// </summary>
    public sealed class Equipment
    {
        public string Id { get; set; } = string.Empty;

        /// <summary>
        /// e.g. "ph_meter", "ec_meter", "thermometer"
        /// This is NOT an enum, intentionally dynamic to support future devices.
        /// </summary>
        public string Type { get; set; } = string.Empty;

        public string DisplayName { get; set; } = string.Empty;

        /// <summary>
        /// Measurements this device supports:
        /// e.g. ["ph", "temperature"], ["ec"], etc.
        /// </summary>
        public List<string> Measurements { get; set; } = new();

        /// <summary>
        /// Whether the device provides built-in ATC (automatic temperature compensation).
        /// </summary>
        public bool TemperatureCompensated { get; set; }

        /// <summary>
        /// Per-measurement tolerances.
        /// Example: { "ph": 0.01, "ec": 2.0 }
        /// </summary>
        public Dictionary<string, decimal> Tolerance { get; set; } = new();

        /// <summary>
        /// Whether defaults may be used when the exact device tolerance is unknown.
        /// </summary>
        public bool ToleranceDefaultAllowed { get; set; } = true;

        public CalibrationProfile Calibration { get; set; } = new CalibrationProfile();

        public ReplaceablePartsProfile ReplaceableParts { get; set; } = new ReplaceablePartsProfile();

        public string? Notes { get; set; }
    }
}
