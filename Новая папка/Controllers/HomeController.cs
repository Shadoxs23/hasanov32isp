using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PersonalExpensesApp.Data;
using PersonalExpensesApp.Security;
using System.Security.Claims;

namespace PersonalExpensesApp.Controllers;

[Authorize]
public class HomeController(AppDbContext db) : Controller
{
    public async Task<IActionResult> Index()
    {
        var userId = long.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
        var isPrivileged = User.IsInRole(RoleNames.Admin) || User.IsInRole(RoleNames.Manager);

        var query = db.Transactions.AsNoTracking();
        if (!isPrivileged) query = query.Where(x => x.UserId == userId);

        var transactions = await query.ToListAsync();
        ViewBag.Income = transactions.Where(x => x.Type == "income").Sum(x => x.Amount);
        ViewBag.Expense = transactions.Where(x => x.Type == "expense").Sum(x => x.Amount);
        ViewBag.Balance = (decimal)ViewBag.Income - (decimal)ViewBag.Expense;
        ViewBag.Count = transactions.Count;
        return View();
    }
}
