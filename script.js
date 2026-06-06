// ── Navbar scroll effect ─────────────────────────────────────────────────────
const navbar = document.getElementById('navbar');
window.addEventListener('scroll', () => {
  navbar.classList.toggle('scrolled', window.scrollY > 40);
}, { passive: true });

// ── Hamburger menu ───────────────────────────────────────────────────────────
const hamburger  = document.getElementById('hamburger');
const mobileMenu = document.getElementById('mobileMenu');

hamburger.addEventListener('click', () => {
  const open = mobileMenu.classList.toggle('open');
  hamburger.setAttribute('aria-expanded', open);
});

// Close mobile menu when a link is clicked
mobileMenu.querySelectorAll('a').forEach(link => {
  link.addEventListener('click', () => mobileMenu.classList.remove('open'));
});

// ── Scroll reveal (Intersection Observer) ────────────────────────────────────
const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      revealObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

document.querySelectorAll('.reveal').forEach(el => revealObserver.observe(el));

// ── Smooth scroll for anchor links ───────────────────────────────────────────
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
  anchor.addEventListener('click', function (e) {
    const target = document.querySelector(this.getAttribute('href'));
    if (!target) return;
    e.preventDefault();
    const offset = 72; // navbar height
    const top = target.getBoundingClientRect().top + window.scrollY - offset;
    window.scrollTo({ top, behavior: 'smooth' });
  });
});

// ── Download button feedback ──────────────────────────────────────────────────
function attachDownloadFeedback(btnId, label) {
  const btn = document.getElementById(btnId);
  if (!btn) return;
  btn.addEventListener('click', function (e) {
    if (this.getAttribute('href') === '#') {
      e.preventDefault();
      showToast(`${label} — download link coming soon!`);
    }
  });
}
attachDownloadFeedback('heroAndroidBtn', '🤖 Android APK');
attachDownloadFeedback('heroIosBtn',     ' iOS / iPhone');
attachDownloadFeedback('heroPcBtn',      '🖥️ PC Version');

// Also handle the main download section buttons
document.querySelectorAll('.dl-btn').forEach(btn => {
  btn.addEventListener('click', function (e) {
    if (this.getAttribute('href') === '#') {
      e.preventDefault();
      if (this.classList.contains('dl-android')) {
        showToast('🤖 Android APK — download link coming soon!');
      } else if (this.classList.contains('dl-ios')) {
        showToast(' iOS / iPhone — download link coming soon!');
      } else {
        showToast('🖥️ Windows installer — download link coming soon!');
      }
    }
  });
});

// ── Toast notification ────────────────────────────────────────────────────────
function showToast(message) {
  const existing = document.querySelector('.afriglow-toast');
  if (existing) existing.remove();

  const toast = document.createElement('div');
  toast.className = 'afriglow-toast';
  toast.textContent = message;

  Object.assign(toast.style, {
    position:       'fixed',
    bottom:         '32px',
    left:           '50%',
    transform:      'translateX(-50%) translateY(20px)',
    background:     '#2E1A0F',
    color:          '#E8C07D',
    padding:        '13px 24px',
    borderRadius:   '100px',
    fontSize:       '13px',
    fontFamily:     "'Poppins', sans-serif",
    fontWeight:     '500',
    border:         '1px solid rgba(212,161,74,0.25)',
    boxShadow:      '0 8px 32px rgba(0,0,0,0.4)',
    zIndex:         '9999',
    opacity:        '0',
    transition:     'opacity 0.3s ease, transform 0.3s ease',
    whiteSpace:     'nowrap',
    pointerEvents:  'none',
  });

  document.body.appendChild(toast);

  requestAnimationFrame(() => {
    toast.style.opacity = '1';
    toast.style.transform = 'translateX(-50%) translateY(0)';
  });

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(-50%) translateY(8px)';
    setTimeout(() => toast.remove(), 350);
  }, 3000);
}

// ── Ingredient pills staggered animation ──────────────────────────────────────
const pillObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const pills = entry.target.querySelectorAll('.ing-pill');
      pills.forEach((pill, i) => {
        setTimeout(() => pill.classList.add('visible'), i * 60);
      });
      pillObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.1 });

const ingGrid = document.querySelector('.ingredients-grid');
if (ingGrid) pillObserver.observe(ingGrid);
