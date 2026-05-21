/* Copy-quote affordance for blockquote.quotable blocks (UNFORGET S74).
   Adds a small "Copy" button to every quotable on the page; on click,
   writes the inner text to the clipboard and flashes "Copied" feedback.
   No-ops if the clipboard API is unavailable (older browsers, insecure context). */
(function () {
  if (!navigator.clipboard || typeof navigator.clipboard.writeText !== 'function') return;

  function init() {
    document.querySelectorAll('blockquote.quotable').forEach(function (quote) {
      if (quote.querySelector('.quotable-copy-btn')) return;

      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'quotable-copy-btn';
      btn.setAttribute('aria-label', 'Copy quote to clipboard');
      btn.textContent = 'Copy';

      btn.addEventListener('click', function () {
        var text = (quote.innerText || quote.textContent || '').trim();
        if (!text) return;
        navigator.clipboard.writeText(text).then(function () {
          btn.textContent = 'Copied';
          btn.classList.add('is-copied');
          setTimeout(function () {
            btn.textContent = 'Copy';
            btn.classList.remove('is-copied');
          }, 1400);
        }).catch(function () {
          btn.textContent = 'Copy failed';
          setTimeout(function () { btn.textContent = 'Copy'; }, 1400);
        });
      });

      quote.appendChild(btn);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
