using System;
using System.Collections.Generic;

namespace WaterChem.Domain.Equipment
{
    /// <summary>
    /// Defines calibration requirements and history
    /// for a measurement device.
    /// </summary>
    public sealed class CalibrationProfile
    {
        /// <summary>
        /// Whether the device requires calibration at all.
        /// </summary>
        public bool Required { get; set; }

        /// <summary>
        /// List of required calibration solution labels:
        /// e.g. ["pH 4.00", "pH 7.00", "pH 10.00"]
        /// </summary>
        public List<string> Solutions { get; set; } = new();

        /// <summary>
        /// History of calibration events.
        /// The engine stores timestamps in ISO 8601 format.
        /// Dates only, no logic.
        /// </summary>
        public List<CalibrationRecord> History { get; set; } = new();

        /// <summary>
        /// How many days a calibration is considered "valid".
        /// Null means no day-based expiration.
        /// </summary>
        public int? ValidDays { get; set; }

        /// <summary>
        /// Calibration validity based on number of readings.
        /// Null means no usage-based expiration.
        /// </summary>
        public int? ValidReadingCount { get; set; }

        /// <summary>
        /// Whether the app should show reminders
        /// based on reading count usage patterns.
        /// </summary>
        public bool UseBasedRecommendations { get; set; }
    }

    public sealed class CalibrationRecord
    {
        /// <summary>
        /// Timestamp of the calibration event.
        /// </summary>
        public DateTime Timestamp { get; set; }

        /// <summary>
        /// Optional notes or reference data.
        /// </summary>
        public string? Notes { get; set; }
    }
}
