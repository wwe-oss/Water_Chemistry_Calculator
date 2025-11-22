namespace WaterChem.Domain.Reagents;

public class Reagent
{
    public string Id { get; set; } = string.Empty;
    public string DisplayName { get; set; } = string.Empty;

    public ReagentState State { get; set; }

    // Chemical formula (purely informational)
    public string? Formula { get; set; }

    // Assay or purity. For solids: %. For liquids: depends on product.
    public decimal? AssayPercent { get; set; }

    // Only applies to liquids
    public decimal? Density_g_per_ml { get; set; }

    // Optional: vendor/manufacturer/product details
    public string? Vendor { get; set; }
    public string? ProductName { get; set; }
    public string? Notes { get; set; }

    // What this reagent can modify
    public List<ReagentTarget> Targets { get; set; } = new();

    // Residue contributions (these DO NOT contain logic; only data)
    public ResidueEffects? Residue { get; set; }

    // Safety/constraints — Engine will interpret them, not the domain.
    public SafetyConstraints? Safety { get; set; }
}
