namespace WaterChem.Domain;

public record CalculationRequest(double VolumeLiters, double TargetPpm, double StockPpm);
