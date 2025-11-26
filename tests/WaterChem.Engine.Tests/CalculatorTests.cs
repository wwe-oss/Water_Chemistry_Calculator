using WaterChem.Domain;
using WaterChem.Engine;
using Xunit;

namespace WaterChem.Engine.Tests;

public class CalculatorTests
{
  [Fact]
  public void ComputeDoseMl_ReturnsExpected()
  {
    var calc = new WaterChemistryCalculator();
    var req = new CalculationRequest(10.0, 50.0, 1000.0); // 10 L, 50 ppm target, 1000 ppm stock
    var ml = calc.ComputeDoseMl(req);
    Assert.InRange(ml, 499.9, 500.1); // ~500 mL
  }

  [Fact]
  public void Add_Works()
  {
    var calc = new WaterChemistryCalculator();
    Assert.Equal(5, calc.Add(2, 3));
  }
}
