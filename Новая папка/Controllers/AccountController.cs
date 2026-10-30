using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PersonalExpensesApp.Data;
using PersonalExpensesApp.Models;
using PersonalExpensesApp.Security;
using PersonalExpensesApp.ViewModels;

namespace PersonalExpensesApp.Controllers;

public class AccountController(
    AppDbContext db,
    IPasswordHasher<User> hasher) : Controller
{
    [HttpGet]
    public IActionResult Login() => View(new LoginVm());

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Login(LoginVm vm)
    {
        if (!ModelState.IsValid) return View(vm);

        var email = vm.Email.Trim().ToLowerInvariant();
        var user = await db.Users.Include(x => x.Role)
            .SingleOrDefaultAsync(x => x.Email.ToLower() == email);

        if (user is null || user.Role is null ||
            hasher.VerifyHashedPassword(user, user.PasswordHash, vm.Password) == PasswordVerificationResult.Failed)
        {
            ModelState.AddModelError("", "Неверная почта или пароль.");
            return View(vm);
        }

        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new(ClaimTypes.Name, user.FullName),
            new(ClaimTypes.Email, user.Email),
            new(ClaimTypes.Role, user.Role.Name)
        };
        var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
        await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme,
            new ClaimsPrincipal(identity));

        return RedirectToAction("Index", "Home");
    }

    [HttpGet]
    public IActionResult Register() => View(new RegisterVm());

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Register(RegisterVm vm)
    {
        if (!ModelState.IsValid) return View(vm);

        var email = vm.Email.Trim().ToLowerInvariant();
        if (await db.Users.AnyAsync(x => x.Email.ToLower() == email))
        {
            ModelState.AddModelError(nameof(vm.Email), "Пользователь с такой почтой уже существует.");
            return View(vm);
        }

        var userRole = await db.Roles.SingleOrDefaultAsync(x => x.Name == RoleNames.User);
        if (userRole is null)
        {
            ModelState.AddModelError("", "В таблице roles не найдена роль «Пользователь».");
            return View(vm);
        }

        var user = new User
        {
            FullName = vm.FullName.Trim(),
            Email = email,
            RoleId = userRole.Id,
            CreatedAt = DateTime.UtcNow
        };
        user.PasswordHash = hasher.HashPassword(user, vm.Password);
        db.Users.Add(user);
        await db.SaveChangesAsync();

        TempData["Success"] = "Регистрация завершена. Теперь войдите в систему.";
        return RedirectToAction(nameof(Login));
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Logout()
    {
        await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
        return RedirectToAction(nameof(Login));
    }

    public IActionResult Denied() => View();
}
