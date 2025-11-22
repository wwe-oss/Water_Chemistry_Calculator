using System.Collections.Generic;

namespace WaterChem.Domain.Equipment
{
    /// <summary>
    /// Defines replaceable parts for an equipment item.
    /// Example: pH probe electrodes, EC probe heads, etc.
    /// </summary>
    public sealed class ReplaceablePartsProfile
    {
        public bool HasReplaceableParts { get; set; }

        public List<ReplaceablePart> Parts { get; set; } = new();
    }

    public sealed class ReplaceablePart
    {
        public string Name { get; set; } = string.Empty;

        public string? Vendor { get; set; }

        public string? ProductName { get; set; }

        public string? PurchaseLink { get; set; }

        public string? Notes { get; set; }
    }
}
