using NodaTime;

namespace WaterChem.Domain.Equipment;

public class CalibrationRecord
{
    public Instant Timestamp { get; set; }   // precise, timezone-safe
    public string? Technician { get; set; }
    public string? Notes { get; set; }

    public Dictionary<string, decimal> Results { get; set; } = new();
}
