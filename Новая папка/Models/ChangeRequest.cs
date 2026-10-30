namespace PersonalExpensesApp.Models;

public class ChangeRequest
{
    public long Id { get; set; }
    public long TransactionId { get; set; }
    public long UserId { get; set; }
    public string RequestText { get; set; } = "";
    public string Status { get; set; } = "pending";
    public DateTime CreatedAt { get; set; }
    public long? ReviewedBy { get; set; }
    public DateTime? ReviewedAt { get; set; }
}
