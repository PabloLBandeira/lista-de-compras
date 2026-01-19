document.addEventListener('DOMContentLoaded', () => {
  const items = document.querySelectorAll('.item');
  items.forEach((item) => {
    item.addEventListener('click', () => {
      alert(`Você clicou no item: ${item.textContent}`);
    });
  });
});
