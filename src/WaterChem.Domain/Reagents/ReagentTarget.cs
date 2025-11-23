namespace WaterChem.Domain.Reagents;

public class ReagentTarget
{
    // mg/L max safe adjustment per dose (optional)
    public decimal? MaxDeltaMgPerL { get; set; }

    // Max allowed pH change per adjustment step (domain-level rule)
    public decimal? MaxPhShift { get; set; }

    // Solubility limits per reagent (g / L)
    public decimal? SolubilityLimit_g_per_L { get; set; }

    // Free-form extensible constraints
    public Dictionary<string, decimal>? Additional { get; set; }
}
