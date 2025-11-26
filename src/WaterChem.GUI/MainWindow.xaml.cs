using System;
using System.Globalization;
using System.Windows;
using WaterChem.Engine;
using WaterChem.Domain;

namespace WaterChem.GUI
{
    public partial class MainWindow : Window
    {
        private readonly WaterChemistryCalculator _calc = new();

        public MainWindow()
        {
            InitializeComponent();
        }

        private void OnComputeClick(object sender, RoutedEventArgs e)
        {
            try
            {
                double vol   = double.Parse(VolumeBox.Text, CultureInfo.InvariantCulture);
                double tgt   = double.Parse(TargetBox.Text, CultureInfo.InvariantCulture);
                double stock = double.Parse(StockBox.Text, CultureInfo.InvariantCulture);

                var req = new CalculationRequest(vol, tgt, stock);
                double ml = _calc.ComputeDoseMl(req);
                ResultText.Text = $"Dose: {ml:F2} mL";
            }
            catch (Exception ex)
            {
                ResultText.Text = $"Error: {ex.Message}";
            }
        }
    }
}
