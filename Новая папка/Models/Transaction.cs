namespace PersonalExpensesApp.Models;

public class Transaction
{
    public long Id { get; set; }
    public long UserId { get; set; }
    public long PaymentMethodId { get; set; }
    public long CategoryId { get; set; }
    public string Type { get; set; } = "";
    public decimal Amount { get; set; }
    public string? Description { get; set; }
    public DateOnly TransactionDate { get; set; }
    public DateTime CreatedAt { get; set; }

    public User? User { get; set; }
    public Category? Category { get; set; }
    public PaymentMethod? PaymentMethod { get; set; }
}
