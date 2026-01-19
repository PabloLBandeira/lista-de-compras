document.addEventListener('DOMContentLoaded', () => {
  const form = document.querySelector('form');
  if (!form) return;
  form.addEventListener('submit', (event) => {
    const name = form.querySelector('[name="user[name]"]');
    const email = form.querySelector('[name="user[email]"]');
    const password = form.querySelector('[name="user[password]"]');
    const passwordConfirmation = form.querySelector('[name="user[password_confirmation]"]');
    if (!name.value || !email.value || !password.value || !passwordConfirmation.value) {
      event.preventDefault();
      alert('Preencha todos os campos obrigatórios.');
    }
    if (password.value !== passwordConfirmation.value) {
      event.preventDefault();
      alert('As senhas não conferem.');
    }
  });
});
