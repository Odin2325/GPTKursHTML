document.addEventListener("DOMContentLoaded", () => {
  const form = document.querySelector("#bestellFormular");
  if (form) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      const name = form.querySelector("input[name='name']").value;
      const gericht = form.querySelector("select[name='gericht']").value;
      alert(`Danke ${name}! Deine Bestellung für "${gericht}" ist eingegangen.`);
      form.reset();
    });
  }
});
