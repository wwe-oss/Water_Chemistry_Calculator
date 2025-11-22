namespace WaterChem.Domain.Plants;

public class GrowthStageProfile
{
    // pH target range
    public decimal? PhMin { get; set; }
    public decimal? PhMax { get; set; }

    // EC target range
    public decimal? EcMin { get; set; }
    public decimal? EcMax { get; set; }

    // Temperature targets (solution temp)
    public decimal? TemperatureMinC { get; set; }
    public decimal? TemperatureMaxC { get; set; }

    // Optional nutrient uptake hints 
    // (NOT used in Engine v1; used during diagnosis/troubleshooting)
    public Dictionary<string, string>? NutrientUptakeNotes { get; set; }
}
