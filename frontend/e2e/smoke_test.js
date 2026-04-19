Feature("Frontend smoke");

Scenario("homepage renders root app", ({ I }) => {
  I.amOnPage("/");
  I.waitForElement("body", 5);
  I.seeElement("body");
});
