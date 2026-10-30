using System.ComponentModel.DataAnnotations;

namespace PersonalExpensesApp.ViewModels;

public class RegisterVm
{
    [Required, StringLength(100, MinimumLength = 2)]
    public string FullName { get; set; } = "";

    [Required, EmailAddress, StringLength(254)]
    public string Email { get; set; } = "";

    [Required, MinLength(8), DataType(DataType.Password)]
    public string Password { get; set; } = "";
}
