using WaterChem.Domain;
using Xunit;

namespace WaterChem.Domain.Tests;

public class PlaceholderTests
{
  [Fact]
  public void CalculationRequest_HoldsValues()
  {
    var req = new CalculationRequest(1.2, 3.4, 5.6);
    Assert.Equal(1.2, req.VolumeLiters);
    Assert.Equal(3.4, req.TargetPpm);
    Assert.Equal(5.6, req.StockPpm);
  }
}
