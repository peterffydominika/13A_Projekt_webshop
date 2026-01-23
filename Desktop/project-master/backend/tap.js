function kosarba(termekNev, termekDb, termekAr) {
    var adatok = {
        nev: termekNev,
        db: Number(termekDb),
        ar: Number(termekAr)
    };

    var regiAdatok = localStorage.getItem("Termék adatai");
    var osszesAdat = [];

    if (regiAdatok) {
        try {
            osszesAdat = JSON.parse(regiAdatok) || [];
        } catch (e) {
            osszesAdat = [];
        }
    }

    // Ha már van ilyen termék, növeljük a darabszámot
    var talalt = false;
    for (var i = 0; i < osszesAdat.length; i++) {
        if (osszesAdat[i].nev === adatok.nev) {
            osszesAdat[i].db = Number(osszesAdat[i].db) + adatok.db;
            talalt = true;
            break;
        }
    }

    if (!talalt) {
        osszesAdat.push(adatok);
    }

    localStorage.setItem("Termék adatai", JSON.stringify(osszesAdat));
    // Optional: update cart UI if present
    if (typeof updateCartBadge === 'function') updateCartBadge();
}

function fizetes() {
    alert('Köszönjük a megrendelésed!');
}

function torles() {
    // Clear only the cart data (avoid wiping other localStorage keys like user data)
    localStorage.removeItem('Termék adatai');
    if (typeof updateCartBadge === 'function') updateCartBadge();
    window.location.reload();
}
// Render the cart table with quantity controls and remove buttons
function renderCart() {
    var kapottadatok = localStorage.getItem('Termék adatai');
    var cart = kapottadatok ? (JSON.parse(kapottadatok) || []) : [];
    var tableEl = document.getElementById('cart-table') || document.getElementById('tabla');
    var totalEl = document.getElementById('cart-total');

    if (!tableEl) return; // nothing to render into

    if (cart.length === 0) {
        tableEl.innerHTML = '<p>A kosár üres.</p>';
        if (totalEl) totalEl.textContent = '0 Ft';
        if (typeof updateCartBadge === 'function') updateCartBadge();
        return;
    }

    var html = '<table class="cart-table" style="width:100%; border-collapse: collapse;">';
    html += '<thead><tr><th style="text-align:left">Termék</th><th>Ár</th><th>Mennyiség</th><th>Részösszeg</th><th></th></tr></thead>';
    html += '<tbody>';
    var ossz = 0;
    for (var i = 0; i < cart.length; i++) {
        var t = cart[i];
        var subtotal = Number(t.ar) * Number(t.db);
        ossz += subtotal;
        html += '<tr data-index="' + i + '">';
        html += '<td>' + escapeHtml(t.nev) + '</td>';
        html += '<td>' + formatCurrency(t.ar) + ' Ft</td>';
        html += '<td style="text-align:center">'
            + '<button onclick="changeQuantity(' + i + ', -1)" aria-label="Csökkent">-</button>'
            + ' <input type="number" min="0" value="' + Number(t.db) + '" onchange="updateQuantityFromInput(' + i + ', this)" style="width:60px;text-align:center;margin:0 6px">'
            + '<button onclick="changeQuantity(' + i + ', 1)" aria-label="Növel">+</button>'
            + '</td>';
        html += '<td style="text-align:right">' + formatCurrency(subtotal) + ' Ft</td>';
        html += '<td style="text-align:center"><button onclick="removeItem(' + i + ')">Töröl</button></td>';
        html += '</tr>';
    }
    html += '</tbody></table>';

    tableEl.innerHTML = html;
    if (totalEl) totalEl.textContent = ossz + ' Ft';
    if (typeof updateCartBadge === 'function') updateCartBadge();
}

// Backwards-compatible alias
function kosar() { renderCart(); }

function saveCart(cart) {
    localStorage.setItem('Termék adatai', JSON.stringify(cart));
    if (typeof updateCartBadge === 'function') updateCartBadge();
}

function changeQuantity(index, delta) {
    var data = JSON.parse(localStorage.getItem('Termék adatai')) || [];
    if (!data[index]) return;
    var newQty = Number(data[index].db) + Number(delta);
    if (newQty <= 0) {
        data.splice(index, 1);
    } else {
        data[index].db = newQty;
    }
    saveCart(data);
    renderCart();
}

function updateQuantityFromInput(index, inputEl) {
    var val = Number(inputEl.value) || 0;
    var data = JSON.parse(localStorage.getItem('Termék adatai')) || [];
    if (!data[index]) return;
    if (val <= 0) {
        data.splice(index, 1);
    } else {
        data[index].db = val;
    }
    saveCart(data);
    renderCart();
}

function removeItem(index) {
    var data = JSON.parse(localStorage.getItem('Termék adatai')) || [];
    if (!data[index]) return;
    data.splice(index, 1);
    saveCart(data);
    renderCart();
}

function formatCurrency(n) {
    return Number(n).toLocaleString('hu-HU');
}

function escapeHtml(text) {
    return String(text).replace(/[&<>"']/g, function (m) { return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":"&#39;"}[m]; });
}

// Small UI helpers: back-to-top button and optional cart badge update
document.addEventListener('DOMContentLoaded', function () {
    var felGomb = document.getElementById('felfele-gomb');
    if (felGomb) {
        window.addEventListener('scroll', function () {
            if (window.scrollY > 200) {
                felGomb.style.display = 'block';
            } else {
                felGomb.style.display = 'none';
            }
        });

        felGomb.addEventListener('click', function () {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }

    // update badge if an element exists
    if (typeof updateCartBadge === 'function') updateCartBadge();
});

// Optional helper: update a cart count element (if you add <span class="cart-count"></span>)
function updateCartBadge() {
    try {
        var data = JSON.parse(localStorage.getItem('Termék adatai')) || [];
        var count = data.reduce(function (acc, item) { return acc + (Number(item.db) || 0); }, 0);
        var badges = document.querySelectorAll('.cart-count');
        badges.forEach(function (el) { el.textContent = count > 0 ? count : ''; });
    } catch (e) { /* ignore */ }
}
