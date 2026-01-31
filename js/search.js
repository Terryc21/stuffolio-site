/**
 * Stuffolio Site Search
 * Client-side search across documentation pages
 */

// Search index - pages and their content
const searchIndex = [
  {
    title: "Home",
    url: "index.html",
    description: "Stuffolio home page. Personal inventory app for iPhone, iPad, and Mac. Track what you buy, protect what you own.",
    keywords: "home inventory app ios mac iphone ipad beta testflight download"
  },
  {
    title: "Features Overview",
    url: "features.html",
    description: "Complete feature list including Stuff Scout AI, Price Watch, warranty tracking, maintenance reminders, and more.",
    keywords: "features stuff scout ai warranty maintenance price watch export barcode scanner photos attachments"
  },
  {
    title: "Compare Apps",
    url: "compare.html",
    description: "Compare Stuffolio to other home inventory apps. Lifecycle vs snapshot approach. Pricing calculator.",
    keywords: "compare comparison sortly itemtopia under my roof everspruce memento pricing subscription"
  },
  {
    title: "Quick Start Guide",
    url: "quick-start.html",
    description: "Get started with Stuffolio in 5 minutes. Add your first item, enable sync, explore features.",
    keywords: "quick start getting started tutorial beginner first steps setup"
  },
  {
    title: "Support & FAQ",
    url: "support.html",
    description: "Get help with Stuffolio. Frequently asked questions, troubleshooting, and contact support.",
    keywords: "support faq help troubleshooting contact email questions answers warranty sync export"
  },
  {
    title: "What's New",
    url: "whats-new.html",
    description: "Changelog and release notes. See what's new in each version of Stuffolio.",
    keywords: "changelog whats new release notes updates version build features improvements fixes"
  },
  {
    title: "App Map",
    url: "app-map.html",
    description: "Visual guide to all screens and features in Stuffolio. Dashboard, item detail, settings, and more.",
    keywords: "app map screens navigation dashboard item detail settings journey acquire own move on"
  },
  {
    title: "Beta Testing Guide",
    url: "beta-testing-guide.html",
    description: "Guide for beta testers. What to test, how to report feedback, testing priorities.",
    keywords: "beta testing testflight feedback bugs report checklist priority"
  },
  {
    title: "Full User Manual",
    url: "Stuffolio_Users_Manual.html",
    description: "Complete reference manual for all Stuffolio features.",
    keywords: "manual documentation reference guide complete full"
  },
  {
    title: "iOS & iPad Guide",
    url: "Stuffolio_Users_Manual_iOS.html",
    description: "iPhone and iPad specific instructions and features.",
    keywords: "ios iphone ipad mobile touch gestures"
  },
  {
    title: "macOS Guide",
    url: "Stuffolio_Users_Manual_macOS.html",
    description: "Mac-specific features and keyboard shortcuts.",
    keywords: "macos mac desktop keyboard shortcuts command menu"
  },
  {
    title: "Quick Reference Card",
    url: "quick-reference.html",
    description: "Printable cheat sheet with keyboard shortcuts and quick tips.",
    keywords: "quick reference card cheat sheet shortcuts print printable"
  },
  {
    title: "Family Sharing",
    url: "family-sharing.html",
    description: "How Family Sharing works with Stuffolio. Share the app with up to 6 family members.",
    keywords: "family sharing apple icloud members share"
  },
  {
    title: "Privacy Policy",
    url: "privacy.html",
    description: "How Stuffolio protects your privacy. Your data stays on your device and in your iCloud.",
    keywords: "privacy policy data protection icloud local storage security"
  },
  {
    title: "Terms of Service",
    url: "terms.html",
    description: "Terms of service for using Stuffolio.",
    keywords: "terms service legal agreement"
  },
  {
    title: "Our Story",
    url: "story.html",
    description: "The story behind Stuffolio. Why we built it and our philosophy.",
    keywords: "story about us philosophy why built motivation"
  },
  {
    title: "Price Watch",
    url: "features.html#price-watch",
    description: "Track replacement costs for your items. Price history, alerts, and multiple sources.",
    keywords: "price watch replacement cost tracking alerts history chart amazon walmart target retail"
  },
  {
    title: "Stuff Scout AI",
    url: "features.html#stuff-scout",
    description: "AI-powered item identification from photos. Get product details, history, and value estimates.",
    keywords: "stuff scout ai photo identification antique collectible value estimate"
  },
  {
    title: "Warranty Tracking",
    url: "features.html#warranty",
    description: "Track warranties with coverage phases, reminders, and Apple Wallet cards.",
    keywords: "warranty tracking coverage phases reminders notifications apple wallet expiration"
  },
  {
    title: "Legacy Wishes",
    url: "features.html#legacy-wishes",
    description: "Document who should receive your belongings. Estate planning made simple.",
    keywords: "legacy wishes estate planning inheritance beneficiary recipient"
  }
];

// Initialize search
function initSearch() {
  // Create search modal HTML
  const searchHTML = `
    <div class="search-modal" id="searchModal">
      <div class="search-container">
        <div class="search-input-wrap">
          <span class="icon">🔍</span>
          <input type="text" class="search-input" id="searchInput" placeholder="Search documentation..." autocomplete="off" />
          <button class="search-close" id="searchClose" aria-label="Close search">×</button>
        </div>
        <div class="search-results" id="searchResults">
          <div class="search-no-results" id="searchPlaceholder">
            Start typing to search...
          </div>
        </div>
        <div class="search-hint">
          Press <kbd>Esc</kbd> to close
        </div>
      </div>
    </div>
  `;

  // Append to body
  document.body.insertAdjacentHTML('beforeend', searchHTML);

  // Get elements
  const modal = document.getElementById('searchModal');
  const input = document.getElementById('searchInput');
  const results = document.getElementById('searchResults');
  const closeBtn = document.getElementById('searchClose');
  const placeholder = document.getElementById('searchPlaceholder');
  const toggleBtn = document.querySelector('.search-toggle');

  // Open search
  function openSearch() {
    modal.classList.add('active');
    input.focus();
    document.body.style.overflow = 'hidden';
  }

  // Close search
  function closeSearch() {
    modal.classList.remove('active');
    input.value = '';
    results.innerHTML = '<div class="search-no-results" id="searchPlaceholder">Start typing to search...</div>';
    document.body.style.overflow = '';
  }

  // Search function
  function performSearch(query) {
    if (!query || query.length < 2) {
      results.innerHTML = '<div class="search-no-results">Start typing to search...</div>';
      return;
    }

    const q = query.toLowerCase();
    const matches = searchIndex.filter(item => {
      return item.title.toLowerCase().includes(q) ||
             item.description.toLowerCase().includes(q) ||
             item.keywords.toLowerCase().includes(q);
    });

    if (matches.length === 0) {
      results.innerHTML = '<div class="search-no-results">No results found for "' + query + '"</div>';
      return;
    }

    results.innerHTML = matches.map(item => `
      <a href="${item.url}" class="search-result">
        <div class="search-result-title">${item.title}</div>
        <div class="search-result-desc">${item.description}</div>
      </a>
    `).join('');
  }

  // Event listeners
  if (toggleBtn) {
    toggleBtn.addEventListener('click', openSearch);
  }

  closeBtn.addEventListener('click', closeSearch);

  modal.addEventListener('click', (e) => {
    if (e.target === modal) closeSearch();
  });

  input.addEventListener('input', (e) => {
    performSearch(e.target.value);
  });

  // Keyboard shortcuts
  document.addEventListener('keydown', (e) => {
    // Cmd/Ctrl + K to open search
    if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
      e.preventDefault();
      openSearch();
    }
    // Escape to close
    if (e.key === 'Escape' && modal.classList.contains('active')) {
      closeSearch();
    }
  });
}

// Mobile menu toggle
function initMobileMenu() {
  const toggleBtn = document.querySelector('.mobile-menu-toggle');
  const nav = document.querySelector('nav');

  if (toggleBtn && nav) {
    toggleBtn.addEventListener('click', () => {
      nav.classList.toggle('active');
      const isOpen = nav.classList.contains('active');
      toggleBtn.setAttribute('aria-expanded', isOpen);
      toggleBtn.innerHTML = isOpen ? '✕' : '☰';
    });
  }
}

// Initialize on DOM ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    initSearch();
    initMobileMenu();
  });
} else {
  initSearch();
  initMobileMenu();
}
