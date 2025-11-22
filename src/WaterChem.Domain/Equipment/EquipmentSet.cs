using System.Collections.Generic;

namespace WaterChem.Domain.Equipment
{
    /// <summary>
    /// Container for multiple equipment entries.
    /// Matches the structure of equipment.json.
    /// </summary>
    public sealed class EquipmentSet
    {
        public List<Equipment> Equipment { get; set; } = new();
    }
}
