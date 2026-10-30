using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using PersonalExpensesApp.Data;
using PersonalExpensesApp.Models;
using PersonalExpensesApp.Security;
using PersonalExpensesApp.ViewModels;

namespace PersonalExpensesApp.Controllers;

[Authorize]
public class TransactionsController(AppDbContext db) : Controller
{
    private long CurrentUserId => long.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    private bool CanSeeAll => User.IsInRole(RoleNames.Admin) || User.IsInRole(RoleNames.Manager);

    public async Task<IActionResult> Index(string? search, string? type, DateOnly? from, DateOnly? to)
    {
        var q = db.Transactions.AsNoTracking()
            .Include(x => x.Category).Include(x => x.PaymentMethod).Include(x => x.User).AsQueryable();

        if (!CanSeeAll) q = q.Where(x => x.UserId == CurrentUserId);
        if (!string.IsNullOrWhiteSpace(search))
            q = q.Where(x => (x.Description ?? "").Contains(search) ||
                             x.Category!.Name.Contains(search));
        if (type is "income" or "expense") q = q.Where(x => x.Type == type);
        if (from.HasValue) q = q.Where(x => x.TransactionDate >= from.Value);
        if (to.HasValue) q = q.Where(x => x.TransactionDate <= to.Value);

        ViewBag.Search = search;
        ViewBag.Type = type;
        ViewBag.From = from?.ToString("yyyy-MM-dd");
        ViewBag.To = to?.ToString("yyyy-MM-dd");
        return View(await q.OrderByDescending(x => x.TransactionDate).ThenByDescending(x => x.Id).ToListAsync());
    }

    [HttpGet]
    public async Task<IActionResult> Create()
    {
        await FillLists();
        return View(new TransactionVm());
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(TransactionVm vm)
    {
        if (!ModelState.IsValid || !await ValidateLookups(vm))
        {
            await FillLists();
            return View(vm);
        }

        var transaction = new Transaction
        {
            UserId = CurrentUserId, CategoryId = vm.CategoryId,
            PaymentMethodId = vm.PaymentMethodId, Type = vm.Type,
            Amount = vm.Amount, Description = vm.Description?.Trim(),
            TransactionDate = vm.TransactionDate, CreatedAt = DateTime.UtcNow
        };
        db.Transactions.Add(transaction);
        await db.SaveChangesAsync();
        await Log("Создание", "transactions", $"Добавлена операция №{transaction.Id}");
        return RedirectToAction(nameof(Index));
    }

    [HttpGet]
    public async Task<IActionResult> Edit(long id)
    {
        var t = await db.Transactions.FirstOrDefaultAsync(x => x.Id == id && (CanSeeAll || x.UserId == CurrentUserId));
        if (t is null) return NotFound();
        await FillLists();
        return View("Create", new TransactionVm {
            Id = t.Id, CategoryId = t.CategoryId, PaymentMethodId = t.PaymentMethodId,
            Type = t.Type, Amount = t.Amount, Description = t.Description, TransactionDate = t.TransactionDate
        });
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(TransactionVm vm)
    {
        if (vm.Id is null) return BadRequest();
        var t = await db.Transactions.FirstOrDefaultAsync(x => x.Id == vm.Id && (CanSeeAll || x.UserId == CurrentUserId));
        if (t is null) return NotFound();
        if (!ModelState.IsValid || !await ValidateLookups(vm))
        {
            await FillLists();
            return View("Create", vm);
        }

        t.CategoryId = vm.CategoryId;
        t.PaymentMethodId = vm.PaymentMethodId;
        t.Type = vm.Type;
        t.Amount = vm.Amount;
        t.Description = vm.Description?.Trim();
        t.TransactionDate = vm.TransactionDate;
        await db.SaveChangesAsync();
        await Log("Изменение", "transactions", $"Изменена операция №{t.Id}");
        return RedirectToAction(nameof(Index));
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(long id)
    {
        var t = await db.Transactions.FirstOrDefaultAsync(x => x.Id == id && (CanSeeAll || x.UserId == CurrentUserId));
        if (t is null) return NotFound();
        db.Transactions.Remove(t);
        await db.SaveChangesAsync();
        await Log("Удаление", "transactions", $"Удалена операция №{id}");
        return RedirectToAction(nameof(Index));
    }

    private async Task<bool> ValidateLookups(TransactionVm vm)
    {
        var category = await db.Categories.FindAsync(vm.CategoryId);
        var methodExists = await db.PaymentMethods.AnyAsync(x => x.Id == vm.PaymentMethodId);
        if (category is null || !methodExists || (vm.Type != "income" && vm.Type != "expense") ||
            category.Type != vm.Type || vm.Amount <= 0)
        {
            ModelState.AddModelError("", "Проверьте категорию, способ оплаты, тип и сумму операции.");
            return false;
        }
        return true;
    }

    private async Task FillLists()
    {
        ViewBag.Categories = new SelectList(await db.Categories.AsNoTracking().OrderBy(x => x.Name).ToListAsync(), "Id", "Name");
        ViewBag.PaymentMethods = new SelectList(await db.PaymentMethods.AsNoTracking().OrderBy(x => x.Name).ToListAsync(), "Id", "Name");
    }

    private async Task Log(string action, string name, string details)
    {
        db.AuditLogs.Add(new AuditLog {
            UserId = CurrentUserId, Action = action, Name = name,
            Details = details, CreatedAt = DateTime.UtcNow
        });
        await db.SaveChangesAsync();
    }
}
