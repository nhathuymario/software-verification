Feature("Auth and syllabus flows");

const lecturerUser = {
  username: "111111111111",
  password: "123456",
};

const badUser = {
  username: "111111111111",
  password: "wrong-password",
};

Before(({ I }) => {
  I.amOnPage("/login");
  I.executeScript(() => {
    sessionStorage.clear();
    localStorage.clear();
  });
});

Scenario("Login thành công và điều hướng đúng role", ({ I }) => {
  I.fillField("Tên người dùng", lecturerUser.username);
  I.fillField("Mật khẩu", lecturerUser.password);
  I.click("Đăng nhập");
  I.waitInUrl("/lecturer", 10);
  I.seeInCurrentUrl("/lecturer");
});

Scenario("Login sai hiện thông báo lỗi", ({ I }) => {
  I.fillField("Tên người dùng", badUser.username);
  I.fillField("Mật khẩu", badUser.password);
  I.click("Đăng nhập");
  I.waitForElement(".uth-alert", 10);
  I.see("không đúng", ".uth-alert");
});

Scenario("API login trả token hợp lệ và frontend lưu token", async ({ I }) => {
  I.fillField("Tên người dùng", lecturerUser.username);
  I.fillField("Mật khẩu", lecturerUser.password);
  I.click("Đăng nhập");
  I.waitInUrl("/lecturer", 10);

  const token = await I.executeScript(
    () =>
      sessionStorage.getItem("token") || sessionStorage.getItem("accessToken"),
  );
  if (!token) {
    throw new Error("Token must be stored in sessionStorage");
  }
  const tokenText = String(token);
  if (
    !tokenText.includes(".") ||
    tokenText.split(".").length < 3 ||
    tokenText.length < 30
  ) {
    throw new Error(`Token format is invalid: ${tokenText}`);
  }
});

Scenario("Route cần quyền thì chặn người chưa login", ({ I }) => {
  I.executeScript(() => {
    sessionStorage.clear();
    localStorage.clear();
  });
  I.amOnPage("/lecturer");
  I.waitInUrl("/login", 10);
  I.seeInCurrentUrl("/login");
});

Scenario("Luồng syllabus chính: tạo và cleanup", async ({ I }) => {
  I.fillField("Tên người dùng", lecturerUser.username);
  I.fillField("Mật khẩu", lecturerUser.password);
  I.click("Đăng nhập");
  I.waitInUrl("/lecturer", 10);
  I.amOnPage("/lecturer/syllabus/new");
  I.waitForElement(".syllabus-form", 10);
  I.waitForElement('select option:not([value="0"])', 10);

  const courseId = await I.grabValueFrom("select");
  if (!courseId || String(courseId) === "0") {
    throw new Error("No valid course found in select options");
  }

  const title = `E2E Syllabus ${Date.now()}`;
  let createdSyllabusId = null;

  try {
    I.fillField(".form-grid > div:nth-child(3) input", title);
    I.fillField(".form-grid > div:nth-child(2) input", "HK1");
    I.fillField(".form-grid > div:nth-child(4) input", "2025-2026");
    I.fillField("textarea", "Created by CodeceptJS E2E");
    I.click("Tạo syllabus");

    I.waitInUrl(`/lecturer/courses/${courseId}`, 10);
    I.waitForText(title, 10);

    const lookup = await I.executeScript(
      async ({ t, cId }) => {
        const token =
          sessionStorage.getItem("token") ||
          sessionStorage.getItem("accessToken");
        if (!token) throw new Error("Missing auth token in sessionStorage");

        const headers = {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        };

        const listResp = await fetch(`/api/lecturer/syllabus/course/${cId}`, {
          headers,
        });
        if (!listResp.ok) {
          throw new Error(`Load syllabi failed: ${listResp.status}`);
        }

        const list = await listResp.json();
        const target = Array.isArray(list)
          ? list.find((s) => String(s?.title || "") === String(t))
          : null;

        if (!target?.id) {
          throw new Error("Created syllabus not found by title");
        }

        return { id: Number(target.id), status: String(target.status || "") };
      },
      { t: title, cId: Number(courseId) },
    );

    createdSyllabusId = lookup.id;
    if (String(lookup.status).toUpperCase() !== "DRAFT") {
      throw new Error(
        `Expected DRAFT right after create, got: ${lookup.status}`,
      );
    }
  } finally {
    if (createdSyllabusId) {
      const cleanup = await I.executeScript(
        async ({ id }) => {
          const token =
            sessionStorage.getItem("token") ||
            sessionStorage.getItem("accessToken");
          if (!token) return { ok: false, reason: "missing-token" };

          const headers = {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          };

          const del = await fetch(`/api/lecturer/syllabus/${id}`, {
            method: "DELETE",
            headers,
          });

          if (del.status === 204) return { ok: true, code: 204 };
          return { ok: false, code: del.status };
        },
        { id: Number(createdSyllabusId) },
      );

      if (!cleanup?.ok) {
        throw new Error(
          `Cleanup failed for syllabus ${createdSyllabusId}, response=${cleanup?.code || cleanup?.reason}`,
        );
      }
    }
  }
});
