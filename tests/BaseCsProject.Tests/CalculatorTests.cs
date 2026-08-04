using Xunit;

namespace BaseCsProject.Tests;

public class CalculatorTests
{
    [Fact]
    public void Twice_ReturnsDoubleTheValue()
    {
        Assert.Equal(4, Calculator.Twice(2));
    }

    [Theory]
    [InlineData(0, 0)]
    [InlineData(3, 6)]
    [InlineData(-5, -10)]
    public void Twice_ReturnsExpectedResult(int value, int expected)
    {
        Assert.Equal(expected, Calculator.Twice(value));
    }
}
