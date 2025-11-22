namespace WaterChem.Domain.Reagents;

public class ResidueEffects
{
    public decimal? Sodium_mg_per_g { get; set; }
    public decimal? Sulfate_mg_per_g { get; set; }
    public decimal? Bicarbonate_mg_per_g { get; set; }
    public decimal? Chloride_mg_per_g { get; set; }

    // Extendable without breaking the model.
    public Dictionary<string, decimal>? AdditionalResidues { get; set; }
}
