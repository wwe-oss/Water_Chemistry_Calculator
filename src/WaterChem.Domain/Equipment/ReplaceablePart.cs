namespace WaterChem.Domain.Equipment;

public class ReplaceablePart
{
    public string Name { get; set; } = string.Empty;

    public string? Vendor { get; set; }
    public string? ProductName { get; set; }
    public string? PurchaseLink { get; set; }

    public string? Notes { get; set; }
}
