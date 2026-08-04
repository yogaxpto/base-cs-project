using System;
using System.Globalization;

namespace BaseCsProject;

/// <summary>
/// Application entry point.
/// </summary>
public static class Program
{
    /// <summary>
    /// Runs the application.
    /// </summary>
    public static void Main()
    {
        Console.WriteLine(Calculator.Twice(3).ToString(CultureInfo.InvariantCulture));
    }
}
