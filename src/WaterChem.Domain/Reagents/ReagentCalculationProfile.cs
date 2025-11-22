using System.Collections.Generic;

namespace WaterChem.Domain.Reagents
{
    /// <summary>
    /// Represents the calculation metadata for a reagent.
    /// This defines:
    ///  - Which metrics it affects
    ///  - How it affects them (ion contributions)
    ///  - Optional molecular constants
    ///  - Any special-case flags the Engine may use
    /// 
    /// Domain objects MUST contain no calculation logic.
    /// This class is strictly a structured data definition.
    /// </summary>
    public sealed class ReagentCalculationProfile
    {
        /// <summary>
        /// What this reagent targets:
        ///   "ph" / "chlorine" / "chloramine" / "alkalinity" etc.
        /// </summary>
        public List<string> Targets { get; set; } = new();

        /// <summary>
        /// Optional molecular mass in g/mol.
        /// Used by the Engine but not required to be populated.
        /// </summary>
        public decimal? MolecularMass { get; set; }

        /// <summary>
        /// Optional acid dissociation constant (Ka).
        /// Useful for reagents that alter pH via acid/base equilibria.
        /// </summary>
        public decimal? AcidDissociationConstant { get; set; }

        /// <summary>
        /// How much sodium (mg), sulfate (mg), etc., is contributed per gram.
        /// Keys are lowercase ion names, e.g.:
        ///   "na": mg of sodium contributed per gram reagent
        ///   "so4": mg of sulfate per gram reagent
        ///   "hplus": mmol of H+ released per gram reagent (optional)
        /// </summary>
        public Dictionary<string, decimal> IonContributionsMgPerGram { get; set; } = new();

        /// <summary>
        /// Whether this reagent should be treated as requiring iterative pH solving.
        /// For acids such as NaHSO4, this is usually true.
        /// </summary>
        public bool RequiresPhSolver { get; set; } = false;

        /// <summary>
        /// Any special flags used by Engine for safety checks.
        /// Examples:
        ///   "strong_acid"
        ///   "reducing_agent"
        /// </summary>
        public List<string> Flags { get; set; } = new();

        /// <summary>
        /// Additional free-form notes for auditing & traceability.
        /// </summary>
        public string? Notes { get; set; }
    }
}
