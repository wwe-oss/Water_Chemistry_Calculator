namespace WaterChem.Domain.Plants;

public class PlantSpecies
{
    public string SpeciesId { get; set; } = string.Empty;
    public string ScientificName { get; set; } = string.Empty;
    public string? CommonName { get; set; }

    // Growth stage profiles for the species
    public Dictionary<string, GrowthStageProfile> StageProfiles { get; set; }
        = new();

    // Cultivars belonging to this species
    public List<PlantCultivar> Cultivars { get; set; } = new();
}
