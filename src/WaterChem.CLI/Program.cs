using System;
using WaterChem.Domain;
using WaterChem.Engine;

namespace WaterChem.CLI
{
    internal class Program
    {
        static int Main(string[] args)
        {
            Console.WriteLine("WaterChem CLI starting…");
            Console.WriteLine($"Args: {string.Join(' ', args)}");

            // TODO: wire in real calls to Engine/Domain
            // var engine = new WaterChemistryCalculator(...);

            return 0;
        }
    }
}
