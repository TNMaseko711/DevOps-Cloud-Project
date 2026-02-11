const API_BASE = window.APP_CONFIG?.apiBaseUrl || '/api';

async function loadProducts() {
  const status = document.getElementById('status');
  const productsContainer = document.getElementById('products');
  try {
    const response = await fetch(`${API_BASE}/products`);
    const products = await response.json();
    status.textContent = `Loaded ${products.length} products`;
    productsContainer.innerHTML = products
      .map((p) => `<div class="card"><strong>${p.name}</strong><br/>$${p.price}</div>`)
      .join('');
  } catch (error) {
    status.textContent = 'API unavailable';
  }
}

window.addEventListener('DOMContentLoaded', loadProducts);
