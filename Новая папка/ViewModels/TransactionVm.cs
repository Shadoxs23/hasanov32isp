using System.ComponentModel.DataAnnotations;
namespace PersonalExpensesApp.ViewModels;

public class TransactionVm
{
    public long? Id { get; set; }
    [Required] public long CategoryId { get; set; }
    [Required] public long PaymentMethodId { get; set; }
    [Required] public string Type { get; set; } = "expense";
    [Range(typeof(decimal), "0.01", "9999999999")] public decimal Amount { get; set; }
    [StringLength(1000)] public string? Description { get; set; }
    [Required] public DateOnly TransactionDate { get; set; } = DateOnly.FromDateTime(DateTime.Today);
}
