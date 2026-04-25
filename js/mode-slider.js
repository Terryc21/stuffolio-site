/* Mode Slider — drag to compare light/dark screenshots
 * Usage: <div class="mode-slider" data-mode-slider>
 *          <img class="mode-slider__dark" src="dark.png" alt="Dark mode">
 *          <img class="mode-slider__light" src="light.png" alt="Light mode">
 *          <div class="mode-slider__handle"></div>
 *        </div>
 */
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("[data-mode-slider]").forEach(function (slider) {
    var handle = slider.querySelector(".mode-slider__handle");
    var lightImg = slider.querySelector(".mode-slider__light");
    var dragging = false;

    function setPosition(x) {
      var rect = slider.getBoundingClientRect();
      var pct = Math.max(0, Math.min(1, (x - rect.left) / rect.width));
      lightImg.style.clipPath = "inset(0 " + ((1 - pct) * 100) + "% 0 0)";
      handle.style.left = (pct * 100) + "%";
    }

    // Set initial position to 50%
    setPosition(0);
    setTimeout(function () {
      var rect = slider.getBoundingClientRect();
      setPosition(rect.left + rect.width * 0.5);
    }, 100);

    slider.addEventListener("pointerdown", function (e) {
      dragging = true;
      slider.setPointerCapture(e.pointerId);
      setPosition(e.clientX);
    });
    slider.addEventListener("pointermove", function (e) {
      if (dragging) setPosition(e.clientX);
    });
    slider.addEventListener("pointerup", function () {
      dragging = false;
    });
    slider.addEventListener("pointercancel", function () {
      dragging = false;
    });
  });
});
