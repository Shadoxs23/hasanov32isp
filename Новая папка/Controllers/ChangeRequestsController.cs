using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PersonalExpensesApp.Data;
using PersonalExpensesApp.Models;
using PersonalExpensesApp.Security;

namespace PersonalExpensesApp.Controllers;

[Authorize]
public class ChangeRequestsController(AppDbContext db) : Controller
{
    private long CurrentUserId => long.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    private bool Reviewer => User.IsInRole(RoleNames.Admin) || User.IsInRole(RoleNames.Manager);

    public async Task<IActionResult> Index()
    {
        var q = db.ChangeRequests.AsNoTracking().AsQueryable();
        if (!Reviewer) q = q.Where(x => x.UserId == CurrentUserId);
        return View(await q.OrderByDescending(x => x.CreatedAt).ToListAsync());
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(long transactionId, string requestText)
    {
        if (string.IsNullOrWhiteSpace(requestText) || requestText.Length > 2000)
            return BadRequest("Напишите запрос (не более 2000 символов).");

        var transaction = await db.Transactions.FirstOrDefaultAsync(x =>
            x.Id == transactionId && (Reviewer || x.UserId == CurrentUserId));
        if (transaction is null) return NotFound();

        db.ChangeRequests.Add(new ChangeRequest {
            TransactionId = transactionId, UserId = CurrentUserId,
            RequestText = requestText.Trim(), Status = "pending", CreatedAt = DateTime.UtcNow
        });
        await db.SaveChangesAsync();
        return RedirectToAction(nameof(Index));
    }

    [Authorize(Policy = "ManagerOrAdmin")]
    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Review(long id, string decision)
    {
        if (decision is not ("approved" or "rejected")) return BadRequest();
        var request = await db.ChangeRequests.FirstOrDefaultAsync(x => x.Id == id && x.Status == "pending");
        if (request is null) return NotFound();

        request.Status = decision;
        request.ReviewedBy = CurrentUserId;
        request.ReviewedAt = DateTime.UtcNow;
        await db.SaveChangesAsync();
        db.AuditLogs.Add(new AuditLog {
            UserId = CurrentUserId, Action = "Рассмотрение запроса",
            Name = "change_requests", Details = $"Запрос №{id}: {decision}",
            CreatedAt = DateTime.UtcNow
        });
        await db.SaveChangesAsync();
        return RedirectToAction(nameof(Index));
    }
}
