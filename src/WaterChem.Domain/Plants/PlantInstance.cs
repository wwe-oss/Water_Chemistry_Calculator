namespace WaterChem.Domain.Plants;

public class PlantInstance
{
    public string InstanceId { get; set; } = string.Empty;
    public string? Nickname { get; set; }

    // Where the plant physically lives
    public string? Location { get; set; }

    // References to water source and equipment profiles
    public string WaterSourceId { get; set; } = string.Empty;
    public List<string> EquipmentIds { get; set; } = new();

    // Optional notes for tracking plant health, issues, etc.
    public string? Notes { get; set; }
}
