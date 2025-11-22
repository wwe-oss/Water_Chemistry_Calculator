namespace WaterChem.Domain.Plants;

public class PlantCultivar
{
    public string CultivarId { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;

    // Optional notes, environmental sensitivities, etc.
    public string? Notes { get; set; }

    // Actual individual plants of this cultivar
    public List<PlantInstance> Instances { get; set; } = new();
}
