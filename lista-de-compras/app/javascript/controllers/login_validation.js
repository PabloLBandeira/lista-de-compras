document.addEventListener('DOMContentLoaded', () => {
  const form = document.querySelector('form');
  if (!form) return;
  form.addEventListener('submit', (event) => {
    const email = form.querySelector('[name="email"]');
    const password = form.querySelector('[name="password"]');
    if (!email.value || !password.value) {
      event.preventDefault();
      alert('Por favor, preencha todos os campos.');
    }
  });
});
