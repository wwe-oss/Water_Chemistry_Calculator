using WaterChem.Domain;

namespace WaterChem.Engine;

public class WaterChemistryCalculator
{
    /// <summary>
    /// Compute milliliters of stock solution required to reach target ppm in given volume.
    /// Assumes 1 ppm = 1 mg/L and stock ppm is mg/L equivalent.
    /// dose(mL) = (Volume(L) * Target(ppm)) / Stock(ppm) * 1000(mL/L)
    /// </summary>
    public double ComputeDoseMl(CalculationRequest req)
    {
        if (req.VolumeLiters <= 0)  throw new ArgumentOutOfRangeException(nameof(req.VolumeLiters));
        if (req.TargetPpm <= 0)     throw new ArgumentOutOfRangeException(nameof(req.TargetPpm));
        if (req.StockPpm <= 0)      throw new ArgumentOutOfRangeException(nameof(req.StockPpm));
        return (req.VolumeLiters * req.TargetPpm / req.StockPpm) * 1000.0;
    }

    // Also leave a trivial method to show wiring/tests
    public int Add(int a, int b) => a + b;
}
